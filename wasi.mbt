/// 文件标识符。stdin stdout stderr分别为0 1 2，preopened dir从3开始编号
pub type FileDescriptor Int

/// 内存区位置。使用时多数情况是从零开始（理论上FFI使用后即释放）
pub type Pos Int derive(Show)

fn fd_write_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_write"

fn fd_read_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_read"

fn args_sizes_get_ffi(arg_length : Int, arg_size : Int) -> Int = "wasi_snapshot_preview1" "args_sizes_get"

fn args_get_ffi(arg_pointers : Int, args : Int) -> Int = "wasi_snapshot_preview1" "args_get"

fn environ_get_ffi(environ_pointers : Int, environ : Int) -> Int = "wasi_snapshot_preview1" "environ_get"

fn environ_sizes_get_ffi(environ_count : Int, environ_buf_size : Int) -> Int = "wasi_snapshot_preview1" "environ_sizes_get"

fn clock_time_get(clock_id : Int, precision : Int64, timeOffset : Int) -> Int = "wasi_snapshot_preview1" "clock_time_get"

fn path_open_ffi(file: Int, dir_flags: Int, path_pos: Int, path_len: Int, oflags: Int, rights_base: Int64, rights_inheriting: Int64, fdflags: Int, result: Int) -> Int = "wasi_snapshot_preview1" "path_open"

/// 时钟种类
pub enum ClockId {
  /// 实际时间
  Realtime
  /// 单调递增
  Monotonic
}

trait WriteToMemory  {
  write(Self, Pos)
  length(Self) -> Int // n element
  size(Self) -> Int // in byte
}

fn write_[T : WriteToMemory](t : T, pos : Pos) {
  t.write(pos)
}

fn length_[T : WriteToMemory](t : T) -> Int {
  t.length()
}

fn size_[T : WriteToMemory](t : T) -> Int {
  t.size()
}

fn WriteToMemory::length(self : Int) -> Int {
  1
}

fn WriteToMemory::size(self : Int) -> Int {
  4
}

fn WriteToMemory::write(self : Int, pos : Pos) {
  store32(pos.0, self)
}

fn write(self : Memory, pos : Pos) {
  write_(self.offset, pos)
  write_(self.len, Pos(pos.0 + size_(self.offset)))
}

fn length(self : Memory) -> Int {
  1
}

fn size(self : Memory) -> Int {
  8
}

fn WriteToMemory::write[T : WriteToMemory](self : List[T], pos : Pos) {
  fn aux(ls : List[T], pos : Pos) {
    match ls {
      Nil => ()
      Cons(hd, tl) => {
        hd.write(pos)
        aux(tl, Pos(pos.0 + hd.size()))
      }
    }
  }

  aux(self, pos)
}

fn WriteToMemory::length[T : WriteToMemory](self : List[T]) -> Int {
  match self {
    Nil => 0
    Cons(_, tl) => 1 + length_(tl)
  }
}

fn WriteToMemory::size[T : WriteToMemory](self : List[T]) -> Int {
  match self {
    Nil => 0
    Cons(hd, tl) => hd.size() + size_(tl)
  }
}

/// fd_write write to file
/// 写文件
pub fn fd_write(bytes : Bytes, file : FileDescriptor, pos : Pos) ->
     Result[Int, Int] {
  let memory = { offset: pos.0, len: bytes.length() }
  memory.from_bytes(bytes)
  let memories = List::Cons(memory, Nil)
  write_(memories, Pos(pos.0 + bytes.length()))
  let errno = fd_write_ffi(
    file.0,
    pos.0 + bytes.length(),
    length_(memories),
    pos.0 + size_(memories),
  )
  if errno == 0 {
    Ok(load32(pos.0 + size_(memories)))
  } else {
    Err(errno)
  }
}

/// fd_read read from a file with given buffer length
/// 读取文件，限定缓冲区大小
pub fn fd_read(file : FileDescriptor, pos : Pos, len : Int) ->
     Result[Bytes, Int] {
  var result = 1
  var errno = 0
  store32(pos.0 + size_(0), pos.0 + size_(0) * 3)
  store32(pos.0 + size_(0) * 2, len)
  errno = fd_read_ffi(file.0, pos.0 + size_(0), 1, pos.0)
  result = load32(pos.0)
  if errno == 0 {
    Ok(Memory::new(pos.0 + size_(0) * 3, result).to_bytes())
  } else {
    Err(errno)
  }
}

/// get_args get command line arguments 获取命令行参数
pub fn get_args(pos : Pos) -> Result[List[Bytes], Int] {
  let errno = args_sizes_get_ffi(pos.0, size_(0))
  if errno != 0 {
    Err(errno)
  } else {
    let argv = load32(pos.0)
    let argc = load32(Pos::Pos(pos.0 + size_(0)).0)
    let errno = args_get_ffi(pos.0, argv * size_(0))
    if errno != 0 {
      Err(errno)
    } else {
      var i : Int = argv - 1
      var list : List[Bytes] = Nil
      while i >= 0 {
        let start = load32(pos.0 + i * size_(0))
        let end = if i != argv - 1 {
          load32(pos.0 + (i + 1) * size_(0))
        } else {
          argv * size_(0) + argc
        }
        let memory = Memory::new(start, end - start)
        let bytes = memory.to_bytes()
        list = Cons(bytes, list)
        i = i - 1
      }
      Ok(list)
    }
  }
}

/// get_environs get environment arguments 获取环境参数
pub fn get_environs(pos: Pos) -> Result[List[Bytes], Int] {
  let errno = environ_sizes_get_ffi(pos.0, size_(0))
  if errno != 0 {
    Err(errno)
  } else {
    let argv = load32(pos.0)
    let argc = load32(Pos::Pos(pos.0 + size_(0)).0)
    let errno = environ_get_ffi(pos.0, argv * size_(0))
    if errno != 0 {
      Err(errno)
    } else {
      var i : Int = argv - 1
      var list : List[Bytes] = Nil
      while i >= 0 {
        let start = load32(pos.0 + i * size_(0))
        let end = if i != argv - 1 {
          load32(pos.0 + (i + 1) * size_(0))
        } else {
          argv * size_(0) + argc
        }
        let memory = Memory::new(start, end - start)
        let bytes = memory.to_bytes()
        list = Cons(bytes, list)
        i = i - 1
      }
      Ok(list)
    }
  }
}

/// Real time -> nano second 纳秒
/// Monotonic -> pico second 皮秒
pub fn get_clock_time(clock_id : ClockId, resolution : Int64, pos : Pos) ->
     Result[Int64, Int] {
  let id = match clock_id {
    Realtime => 0
    Monotonic => 1
  }
  let errno = clock_time_get(id, resolution, pos.0)
  if errno != 0 {
    Err(errno)
  } else {
    Ok(load64(pos.0))
  }
}

/// 打开新的文件
pub fn path_open(self: FileDescriptor, dirflags: LookupFlag, path: String, oflags: OpenFlag, rights_base: FDRight, rights_inheriting: FDRight, flags: FDFlag, pos: Pos) -> Result[FileDescriptor, Int] {
  let memory = { offset: pos.0, len: path.length() }
  memory.from_bytes(path.to_bytes())
  let result = pos.0 + path.length()
  let errno = path_open_ffi(self.0, dirflags.0, pos.0, path.length(), oflags.0, rights_base.0, rights_inheriting.0, flags.0, result)
  if errno != 0 {
    Err(errno)
  } else {
    Ok(FileDescriptor(load32(result)))
  }
}

priv struct Memory {
  offset : Int
  len : Int
}

fn load8(pos : Int) -> Int = "(func $load8 (param $pos i32) (result i32) (i32.load8_u (local.get $pos)))"

fn load32(pos : Int) -> Int = "(func $load32 (param $pos i32) (result i32) (i32.load (local.get $pos)))"

fn load64(pos : Int) -> Int64 = "(func $load64 (param $pos i32) (result i64) (i64.load (local.get $pos)))"

fn store8(pos : Int, value : Int) = "(func $store8 (param $pos i32) (param $value i32) (i32.store8 (local.get $pos) (local.get $value)))"

fn store32(pos : Int, value : Int) = "(func $store32 (param $pos i32) (param $value i32) (i32.store (local.get $pos) (local.get $value)))"

fn store64(pos : Int, value : Int64) = "(func $store64 (param $pos i32) (param $value i64) (i64.store (local.get $pos) (local.get $value)))"

fn to_bytes(self : Memory) -> Bytes {
  let bytes = Bytes::make(self.len, 0)
  var i = 0
  while i < self.len {
    bytes[i] = load8(self.offset + i)
    i = i + 1
  }
  bytes
}

fn from_bytes(self : Memory, bytes : Bytes) -> Unit {
  fn min(i, j) {
    if i < j {
      i
    } else {
      j
    }
  }

  var i = 0
  while i < min(self.len, bytes.length()) {
    store8(self.offset + i, bytes[i])
    i = i + 1
  }
}

fn Memory::new(offset : Int, len : Int) -> Memory {
  { offset, len }
}

/// 标准输入（0）
pub let stdin : FileDescriptor = FileDescriptor(0)

/// 标准输出（1）
pub let stdout : FileDescriptor = FileDescriptor(1)

/// 标准错误输出（2）
pub let stderr : FileDescriptor = FileDescriptor(2)