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

/// Output a string
/// 输出字符串
pub fn print(self : FileDescriptor, str : String) -> Unit {
  fd_write(str.to_bytes(), self).unwrap() |> ignore
}

/// Output a string with a new line ending
/// 输出字符串（带换行符）
pub fn println(self : FileDescriptor, str : String) -> Unit {
  self.print(str + "\n")
}

pub fn write(self : FileDescriptor, content : Bytes) -> Result[Int, Int] {
  fd_write(content, self)
}

/// Read a single byte, -1 if end of stream
/// 读取一个字节, 如果没有内容则返回-1
pub fn read(self : FileDescriptor) -> Result[Int, Int] {
  let bytes = fd_read(self, 1)?
  if bytes.length() < 1 {
    Ok(-1)
  } else {
    Ok(bytes[0])
  }
}

/// Read up to a specified number of bytes
/// 读特定数量的字节
pub fn read_n_bytes(self : FileDescriptor, len : Int) -> Result[Bytes, Int] {
  fd_read(self, len)
}

/// Read all bytes with a buffer
/// 读取所有字节，依照给定的缓冲区大小
pub fn read_all_bytes(self : FileDescriptor, len : Int) -> Result[Bytes, Int] {
  let (bytes, count) : (List[Bytes], Int) = loop List::Nil, 0 {
    bytes, count => {
      let res = self.read_n_bytes(len)?
      let res_len = res.length()
      if res_len == len {
        continue Cons(res, bytes),
          count + res_len
      } else {
        break (Cons(res, bytes), count + res_len)
      }
    }
  }
  let result = Bytes::make(count, 0)
  loop bytes, count {
    Cons(hd, tl), count => {
      let res_len = hd.length()
      result.blit(count - res_len, hd, 0, res_len)
      continue tl,
        count - res_len
    }
    Nil, _ => ()
  }
  Ok(result)
}

/// Return whatever comes next
/// Not necessarily one line
/// 返回接下来的无论什么东西，不一定是一行
pub fn next(in : FileDescriptor) -> String {
  let mut bytes = Bytes::make(0, 0)
  let buffer = 4096
  let mut result = buffer
  while result == buffer {
    let read = fd_read(in, buffer).unwrap()
    result = read.length()
    let b = Bytes::make(bytes.length() + result, 0)
    b.blit(0, bytes, 0, bytes.length())
    b.blit(bytes.length(), read, 0, result)
    bytes = b
  }
  bytes.to_string()
}

/// A scanner that will read things progressively
/// 一点点读的扫描器
pub struct Scanner {
  priv mut str : String
  priv in : FileDescriptor
}

/// Create a scanner from a file descriptor
/// 从文件标识符创建新的扫描器
pub fn Scanner::make(in : FileDescriptor) -> Scanner {
  { str: "", in }
}

/// Read next line
/// None if there's nothing more to read
/// 读下一行。如果None说明没东西可读了
pub fn next_line(self : Scanner) -> Option[String] {
  let mut i = 0
  if self.str.length() == 0 {
    self.str = next(self.in)
  }
  while i < self.str.length() {
    if self.str[i] == '\n' {
      let bytes = self.str.to_bytes()
      let result = bytes.sub_string(0, i)
      self.str = bytes.sub_string(i + 1, self.str.length() - i - 1)
      return Some(result)
    }
    i = i + 1
    if i == self.str.length() {
      self.str = self.str + next(self.in)
    }
  }
  if self.str.length() > 0 {
    let result = self.str
    self.str = ""
    Some(result)
  } else {
    None
  }
}
