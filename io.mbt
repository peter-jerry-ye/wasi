/// Output a string
/// 输出字符串
pub fn print(self: FileDescriptor, str : String, pos : Pos) {
  fd_write(str.to_bytes(), self, pos)
  ()
}

/// Output a string with a new line ending
/// 输出字符串（带换行符）
pub fn println(self: FileDescriptor, str : String, pos : Pos) {
  self.print(str + "\n", pos)
}

/// Return whatever comes next
/// Not necessarily one line
/// 返回接下来的无论什么东西，不一定是一行
pub fn next(in: FileDescriptor, pos : Pos) -> String {
  var bytes = Bytes::make(0, 0)
  let buffer = 4096
  var result = buffer
  while result == buffer {
    let res = fd_read(in, pos, buffer)
    match res {
      Ok(read) => {
        result = read.length()
        let b = Bytes::make(bytes.length() + result, 0)
        b.blit(0, bytes, 0, bytes.length())
        b.blit(bytes.length(), read, 0, result)
        bytes = b
      }
    }
  }
  bytes.to_string()
}

/// A scanner that will read things progressively
/// 一点点读的扫描器
pub struct Scanner {
  priv mut str : String
  priv in: FileDescriptor
}

/// Create a scanner from a file descriptor
/// 从文件标识符创建新的扫描器
pub fn Scanner::make(in: FileDescriptor) -> Scanner {
  { str : "", in }
}

/// Read next line
/// None if there's nothing more to read
/// 读下一行。如果None说明没东西可读了
pub fn next_line(self : Scanner, pos : Pos) -> Option[String] {
  var i = 0
  if self.str.length() == 0 {
    self.str = next(self.in, pos)
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
      self.str = self.str + next(self.in, pos)
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
