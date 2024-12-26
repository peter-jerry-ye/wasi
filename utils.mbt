/// Decode a UTF-8 byte array into a string
pub fn decode_utf8(bytes : FixedArray[Byte]) -> String {
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
  buffer.contents().to_unchecked_string()
}

/// Encode a string into a UTF-8 byte array
pub fn encode_utf8(string : String) -> FixedArray[Byte] {
  let bytes : FixedArray[Byte] = FixedArray::make(string.length() * 4, 0)
  let length = loop 0, 0 {
    offset, chari =>
      if chari < string.length() {
        let code = string[chari].to_uint()
        if code < 0x80 {
          bytes[offset] = ((code & 0x7F) | 0x00).to_byte()
          continue offset + 1, chari + 1
        } else if code < 0x0800 {
          bytes[offset] = (((code >> 6) & 0x1F) | 0xC0).to_byte()
          bytes[offset + 1] = ((code & 0x3F) | 0x80).to_byte()
          continue offset + 2, chari + 2
        } else if code < 0x010000 {
          bytes[offset] = (((code >> 12) & 0x0F) | 0xE0).to_byte()
          bytes[offset + 1] = (((code >> 6) & 0x3F) | 0x80).to_byte()
          bytes[offset + 2] = ((code & 0x3F) | 0x80).to_byte()
          continue offset + 3, chari + 1
        } else if code < 0x110000 {
          bytes[offset] = (((code >> 18) & 0x07) | 0xF0).to_byte()
          bytes[offset + 1] = (((code >> 12) & 0x3F) | 0x80).to_byte()
          bytes[offset + 2] = (((code >> 6) & 0x3F) | 0x80).to_byte()
          bytes[offset + 3] = ((code & 0x3F) | 0x80).to_byte()
          continue offset + 4, chari + 1
        } else {
          abort("Char out of range")
        }
      } else {
        offset
      }
  }
  let result : FixedArray[Byte] = FixedArray::make(length, 0)
  bytes.blit_to(result, len=length)
  result
}
