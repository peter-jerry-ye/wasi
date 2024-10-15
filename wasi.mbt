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

/// 文件标识符。stdin stdout stderr分别为0 1 2，preopened dir从3开始编号
pub type FileDescriptor Int

fn fd_write_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_write"

fn fd_read_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_read"

fn args_sizes_get_ffi(arg_length : Int, arg_size : Int) -> Int = "wasi_snapshot_preview1" "args_sizes_get"

fn args_get_ffi(arg_pointers : Int, args : Int) -> Int = "wasi_snapshot_preview1" "args_get"

fn environ_get_ffi(environ_pointers : Int, environ : Int) -> Int = "wasi_snapshot_preview1" "environ_get"

fn environ_sizes_get_ffi(environ_count : Int, environ_buf_size : Int) -> Int = "wasi_snapshot_preview1" "environ_sizes_get"

fn clock_time_get_ffi(
  clock_id : Int,
  precision : Int64,
  time_offset : Int
) -> Int = "wasi_snapshot_preview1" "clock_time_get"

fn path_open_ffi(
  file : Int,
  dir_flags : Int,
  path_pos : Int,
  path_len : Int,
  oflags : Int,
  rights_base : Int64,
  rights_inheriting : Int64,
  fdflags : Int,
  result : Int
) -> Int = "wasi_snapshot_preview1" "path_open"

fn sock_accept_ffi(fd : Int, fdflags : Int, result : Int) -> Int = "wasi_snapshot_preview1" "sock_accept"

fn proc_exit_ffi(exitcode : Int) = "wasi_snapshot_preview1" "proc_exit"

/// 时钟种类
pub enum ClockId {
  /// 实际时间
  Realtime
  /// 单调递增
  Monotonic
}

/// Write to a file descriptor.
/// Note: This is similar to `writev` in POSIX.
///
/// Like POSIX, any calls of `write` (and other functions to read or write)
/// for a regular file by other threads in the WASI process should not be
/// interleaved while `write` is executed.
pub fn fd_write(
  file : FileDescriptor,
  contents : Array[Bytes]
) -> Result[Int, Int] {
  let ptr = @ffi.malloc(contents.length() * (4 + 4))
  let result = @ffi.malloc(4)
  for i, bytes in contents {
    let ptr_bytes = @ffi.bytes2ptr(bytes)
    @ffi.store32(ptr + i * 8, ptr_bytes)
    @ffi.free(ptr_bytes)
    @ffi.store32(ptr + i * 8 + 4, bytes.length())
  }
  let errno = fd_write_ffi(file._, ptr, 1, result)
  let res = if errno == 0 { Ok(@ffi.load32(result)) } else { Err(errno) }
  @ffi.free(result)
  @ffi.free(ptr)
  res
}

/// Read from a file descriptor.
/// Note: This is similar to `readv` in POSIX.
pub fn fd_read(
  file : FileDescriptor,
  contents : Array[Bytes]
) -> Result[Int, Int] {
  let iovs = @ffi.malloc(contents.length() * 4)
  let result = @ffi.malloc(4)
  for i, bytes in contents {
    @ffi.store32(iovs + i * 4, bytes.length())
  }
  let errno = fd_read_ffi(file._, iovs, 1, result)
  let res = if errno == 0 { Ok(@ffi.load32(result)) } else { Err(errno) }
  @ffi.free(result)
  @ffi.free(iovs)
  res
}

/// Read command-line argument data.
/// 
/// The size of the array should match that returned by `args_sizes_get`.
/// 
/// Each argument is expected to be `\0` terminated.
/// The first argument should be a string containing the "name" of the
/// program. This need not be a usable filesystem path or even file name,
/// and may even be a fixed string. Subsequent arguments are the arguments
/// passed to the program by the user.
pub fn get_args() -> Result[Array[Bytes], Int] {
  let argc_m = @ffi.malloc(4)
  let argv_size_m = @ffi.malloc(4)
  let errno = args_sizes_get_ffi(argc_m, argv_size_m)
  if errno != 0 {
    @ffi.free(argv_size_m)
    @ffi.free(argc_m)
    return Err(errno)
  }
  let argc = @ffi.load32(argc_m)
  @ffi.free(argc_m)
  let argv_size = @ffi.load32(argv_size_m)
  @ffi.free(argv_size_m)
  if argc == 0 {
    return Ok([])
  }
  let arg_pos_m = @ffi.malloc(argc * 4)
  let bytes = Bytes::new(argv_size)
  let arg_m = @ffi.bytes2ptr(bytes)
  let errno = args_get_ffi(arg_pos_m, arg_m)
  if errno != 0 {
    @ffi.free(arg_m)
    @ffi.free(arg_pos_m)
    return Err(errno)
  }
  let args = []
  for i = argc - 1; i >= 0; i = i - 1 {
    let start = @ffi.load32(arg_pos_m + i * 4) - arg_m
    let end = if i != argc - 1 {
      @ffi.load32(arg_pos_m + (i + 1) * 4) - arg_m
    } else {
      argv_size
    }
    let b = Bytes::new(end - start)
    b.blit(0, bytes, start, end - start)
    args.push(b)
  }
  @ffi.free(arg_m)
  @ffi.free(arg_pos_m)
  Ok(args.rev())
}

/// Read environment variable data.
/// The sizes of the buffers should match that returned by `environ_sizes_get`.
/// Key/value pairs are expected to be joined with `=`s, and terminated with `\0`s.
pub fn get_environs() -> Result[Array[Bytes], Int] {
  let argc_m = @ffi.malloc(4)
  let argv_size_m = @ffi.malloc(4)
  let errno = environ_sizes_get_ffi(argc_m, argv_size_m)
  if errno != 0 {
    @ffi.free(argv_size_m)
    @ffi.free(argc_m)
    return Err(errno)
  }
  let argc = @ffi.load32(argc_m)
  @ffi.free(argc_m)
  let argv_size = @ffi.load32(argv_size_m)
  @ffi.free(argv_size_m)
  if argc == 0 {
    return Ok([])
  }
  let arg_pos_m = @ffi.malloc(argc * 4)
  let bytes = Bytes::new(argv_size)
  let arg_m = @ffi.bytes2ptr(bytes)
  let errno = environ_get_ffi(arg_pos_m, arg_m)
  if errno != 0 {
    @ffi.free(arg_m)
    @ffi.free(arg_pos_m)
    return Err(errno)
  }
  let args = []
  for i = argc - 1; i >= 0; i = i - 1 {
    let start = @ffi.load32(arg_pos_m + i * 4) - arg_m
    let end = if i != argc - 1 {
      @ffi.load32(arg_pos_m + (i + 1) * 4) - arg_m
    } else {
      argv_size
    }
    let b = Bytes::new(end - start)
    b.blit(0, bytes, start, end - start)
    args.push(b)
  }
  @ffi.free(arg_m)
  @ffi.free(arg_pos_m)
  Ok(args.rev())
}

/// Return the time value of a clock.
/// Note: This is similar to `clock_gettime` in POSIX.
pub fn get_clock_time(
  clock_id : ClockId,
  resolution : Int64
) -> Result[Int64, Int] {
  let id = match clock_id {
    Realtime => 0
    Monotonic => 1
  }
  let m = @ffi.malloc(8)
  let errno = clock_time_get_ffi(id, resolution, m)
  let res = if errno != 0 { Err(errno) } else { Ok(@ffi.load64(m)) }
  @ffi.free(m)
  res
}

/// 打开新的文件
pub fn path_open(
  self : FileDescriptor,
  dirflags : LookupFlag,
  path : String,
  oflags : OpenFlag,
  rights_base : FDRight,
  rights_inheriting : FDRight,
  flags : FDFlag
) -> Result[FileDescriptor, Int] {
  let path = encode_utf8(path)
  let path_ptr = @ffi.bytes2ptr(path)
  let result = @ffi.malloc(4)
  let errno = path_open_ffi(
    self._,
    dirflags._,
    path_ptr,
    path.length(),
    oflags._,
    rights_base._,
    rights_inheriting._,
    flags._,
    result,
  )
  let res = if errno != 0 {
    Err(errno)
  } else {
    Ok(FileDescriptor(@ffi.load32(result)))
  }
  @ffi.free(result)
  @ffi.free(path_ptr)
  res
}

pub let stdin : FileDescriptor = FileDescriptor(0)

pub let stdout : FileDescriptor = FileDescriptor(1)

pub let stderr : FileDescriptor = FileDescriptor(2)

/// Terminate the process normally. An exit code of 0 indicates successful
/// termination of the program. The meanings of other values is dependent on
/// the environment.
pub fn process_exit(exitcode : Int) -> Unit {
  proc_exit_ffi(exitcode)
}

/// Accept a new incoming connection.
/// Note: This is similar to `accept` in POSIX.
pub fn accept_socket(
  self : FileDescriptor,
  flags : FDFlag
) -> Result[FileDescriptor, Int] {
  let result = @ffi.malloc(4)
  let errno = sock_accept_ffi(self._, flags._, result)
  let res = if errno != 0 {
    Err(errno)
  } else {
    Ok(FileDescriptor(@ffi.load32(result)))
  }
  @ffi.free(result)
  res
}
