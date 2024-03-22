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

priv struct Resource[R] {
  acquire : () -> R
  free : (R) -> Unit
}

fn use[R, T](self : Resource[R], f : (R) -> T) -> T {
  let resource = (self.acquire)()
  let result = f(resource)
  (self.free)(resource)
  result
}

fn memory(len : Int) -> Resource[@memory.Memory] {
  {
    acquire: fn() { @memory.allocate(len).unwrap() },
    free: fn(memory) { memory.free().unwrap() },
  }
}

/// fd_write write to file
/// 写文件
pub fn fd_write(bytes : Bytes, file : FileDescriptor) -> Result[Int, Int] {
  memory(bytes.length()).use(
    fn(buffer) {
      memory(8).use(
        fn(ptr) {
          memory(4).use(
            fn(result) {
              buffer.store_bytes(bytes)
              ptr.store32(0, buffer.offset) |> ignore
              ptr.store32(4, buffer.length) |> ignore
              let errno = fd_write_ffi(file.0, ptr.offset, 1, result.offset)
              if errno == 0 {
                // TODO : Remove
                buffer.store_bytes(Bytes::make(bytes.length(), 0))
                Ok(result.load32(0).unwrap())
              } else {
                Err(errno)
              }
            },
          )
        },
      )
    },
  )
}

/// fd_read read from a file with given buffer length
/// 读取文件，限定缓冲区大小
pub fn fd_read(file : FileDescriptor, len : Int) -> Result[Bytes, Int] {
  memory(len).use(
    fn(buffer) {
      memory(8).use(
        fn(ptr) {
          memory(4).use(
            fn(result) {
              ptr.store32(0, buffer.offset) |> ignore
              ptr.store32(4, buffer.length) |> ignore
              let errno = fd_read_ffi(file.0, ptr.offset, 1, result.offset)
              if errno == 0 {
                let size = result.load32(0).unwrap()
                let bytes = buffer.load_bytes()
                let b = Bytes::make(size, 0)
                b.blit(0, bytes, 0, size)
                Ok(b)
              } else {
                Err(errno)
              }
            },
          )
        },
      )
    },
  )
}

/// get_args get command line arguments 获取命令行参数
pub fn get_args() -> Result[List[Bytes], Int] {
  memory(4).use(
    fn(argc_m) {
      memory(4).use(
        fn(argv_size_m) {
          let errno = args_sizes_get_ffi(argc_m.offset, argv_size_m.offset)
          if errno != 0 {
            Err(errno)
          } else {
            let argc = argc_m.load32(0).unwrap()
            let argv_size = argv_size_m.load32(0).unwrap()
            if (argc == 0) { return Ok(Nil) }
            memory(argc * 4).use(
              fn(arg_pos_m) {
                memory(argv_size).use(
                  fn(arg_m) {
                    let errno = args_get_ffi(arg_pos_m.offset, arg_m.offset)
                    if errno != 0 {
                      Err(errno)
                    } else {
                      let mut i : Int = argc - 1
                      let mut list : List[Bytes] = Nil
                      let bytes = arg_m.load_bytes()
                      while i >= 0 {
                        let start = arg_pos_m.load32(i * 4).unwrap() - arg_m.offset
                        let end = if i != argc - 1 {
                          arg_pos_m.load32((i + 1) * 4).unwrap() - arg_m.offset
                        } else {
                          argv_size
                        }
                        let b = Bytes::make(end - start, 0)
                        b.blit(0, bytes, start, end - start)
                        list = Cons(b, list)
                        i = i - 1
                      }
                      Ok(list)
                    }
                  },
                )
              },
            )
          }
        },
      )
    },
  )
}

/// get_environs get environment arguments 获取环境参数
pub fn get_environs() -> Result[List[Bytes], Int] {
  memory(4).use(
    fn(argc_m) {
      memory(4).use(
        fn(argv_size_m) {
          let errno = environ_sizes_get_ffi(argc_m.offset, argv_size_m.offset)
          if errno != 0 {
            Err(errno)
          } else {
            let argc = argc_m.load32(0).unwrap()
            let argv_size = argv_size_m.load32(0).unwrap()
            if (argc == 0) { return Ok(Nil) }
            memory(argc * 4).use(
              fn(arg_pos_m) {
                memory(argv_size).use(
                  fn(arg_m) {
                    let errno = environ_get_ffi(arg_pos_m.offset, arg_m.offset)
                    if errno != 0 {
                      Err(errno)
                    } else {
                      let mut i : Int = argc - 1
                      let mut list : List[Bytes] = Nil
                      let bytes = arg_m.load_bytes()
                      while i >= 0 {
                        let start = arg_pos_m.load32(i * 4).unwrap() - arg_m.offset
                        let end = if i != argc - 1 {
                          arg_pos_m.load32((i + 1) * 4).unwrap() - arg_m.offset
                        } else {
                          argv_size
                        }
                        let b = Bytes::make(end - start, 0)
                        b.blit(0, bytes, start, end - start)
                        list = Cons(b, list)
                        i = i - 1
                      }
                      Ok(list)
                    }
                  },
                )
              },
            )
          }
        },
      )
    },
  )
}

/// Real time -> nano second 纳秒
/// Monotonic -> pico second 皮秒
pub fn get_clock_time(
  clock_id : ClockId,
  resolution : Int64
) -> Result[Int64, Int] {
  let id = match clock_id {
    Realtime => 0
    Monotonic => 1
  }
  memory(8).use(
    fn(m) {
      let errno = clock_time_get_ffi(id, resolution, m.offset)
      if errno != 0 {
        Err(errno)
      } else {
        Ok(m.load64(0).unwrap())
      }
    },
  )
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
  memory(path.length()).use(
    fn(m) {
      m.store_bytes(path.to_bytes())
      memory(4).use(
        fn(result) {
          let errno = path_open_ffi(
            self.0,
            dirflags.0,
            m.offset,
            path.length(),
            oflags.0,
            rights_base.0,
            rights_inheriting.0,
            flags.0,
            result.offset,
          )
          if errno != 0 {
            Err(errno)
          } else {
            Ok(FileDescriptor(result.load32(0).unwrap()))
          }
        },
      )
    },
  )
}

/// 标准输入（0）
pub let stdin : FileDescriptor = FileDescriptor(0)

/// 标准输出（1）
pub let stdout : FileDescriptor = FileDescriptor(1)

/// 标准错误输出（2）
pub let stderr : FileDescriptor = FileDescriptor(2)

/// exit process 退出进程
pub fn process_exit(exitcode : Int) -> Unit {
  proc_exit_ffi(exitcode)
}

/// accept socket 接受socket
pub fn accept_socket(
  self : FileDescriptor,
  flags : FDFlag
) -> Result[FileDescriptor, Int] {
  memory(4).use(
    fn(result) {
      let errno = sock_accept_ffi(self.0, flags.0, result.offset)
      if errno != 0 {
        Err(errno)
      } else {
        Ok(FileDescriptor(result.load32(0).unwrap()))
      }
    },
  )
}
