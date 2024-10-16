/// Decode a UTF-8 byte array into a string
fn decode_utf8(bytes : Bytes) -> String {
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
fn encode_utf8(string : String) -> Bytes {
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
