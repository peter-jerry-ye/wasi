// Copyright 2024 peter-jerry-ye
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pub enum CharSet {
  UTF8
  UTF16
}

/// Output a string
/// 输出字符串
pub fn print(
  self : FileDescriptor,
  str : String,
  ~charset : CharSet = UTF8
) -> Unit {
  match charset {
    UTF16 => fd_write(self, [str.to_bytes()]).unwrap() |> ignore
    UTF8 => fd_write(self, [encode_utf8(str)]).unwrap() |> ignore
  }
}

/// Output a string with a new line ending
/// 输出字符串（带换行符）
pub fn println(
  self : FileDescriptor,
  str : String,
  ~charset : CharSet = UTF8
) -> Unit {
  self.print(str + "\n", ~charset)
}

/// Decode a UTF-8 byte array into a string
pub fn decode_utf8(bytes : Bytes) -> String {
  let buffer = @buffer.new(size_hint=bytes.length() * 4)
  for i = 0; i < bytes.length(); {
    let byte = bytes[i].to_int()
    if byte < 0b10000000 {
      buffer.write_char(Char::from_int(byte))
      continue i + 1
    } else if byte < 0b11100000 && i + 1 < bytes.length() {
      buffer.write_char(
        Char::from_int(
          ((byte & 0b11111) >> 6) | (bytes[i + 1].to_int() & 0b111111),
        ),
      )
      continue i + 2
    } else if byte < 0b11110000 && i + 2 < bytes.length() {
      buffer.write_char(
        Char::from_int(
          ((byte & 0b1111) << 12) |
          ((bytes[i + 1].to_int() & 0b111111) << 6) |
          (bytes[i + 2].to_int() & 0b111111),
        ),
      )
      continue i + 3
    } else if byte < 0b11111000 && i + 3 < bytes.length() {
      buffer.write_char(
        Char::from_int(
          ((byte & 0b111) << 18) |
          ((bytes[i + 1].to_int() & 0b111111) << 12) |
          ((bytes[i + 2].to_int() & 0b111111) << 6) |
          (bytes[i + 3].to_int() & 0b111111),
        ),
      )
      continue i + 4
    } else {
      break // let it go ~
    }
  }
  buffer.to_string()
}

/// Encode a string into a UTF-8 byte array
pub fn encode_utf8(string : String) -> Bytes {
  let bytes = Bytes::new(string.length() * 4)
  let length = loop 0, 0 {
    offset, chari =>
      if chari < string.length() {
        continue offset + bytes.set_utf8_char(offset, string[chari]), chari + 1
      } else {
        offset
      }
  }
  let result = Bytes::new(length)
  result.blit(0, bytes, 0, length)
  result
}
