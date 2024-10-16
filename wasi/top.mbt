fn args_sizes_get_ffi(argc : Int, size : Int) -> UInt = "wasi_snapshot_preview1" "args_sizes_get"

/// Return command-line argument data sizes.
/// 
/// @return `(argc, size)` where `argc` is the number of arguments and `size` is the size of the argument data.
pub fn args_sizes_get() -> (Int, Int)!@types.Errno {
  let argc_ptr = @ffi.malloc(4)
  let size_ptr = @ffi.malloc(4)
  let ret = args_sizes_get_ffi(argc_ptr, size_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  let argc = @ffi.load32(argc_ptr)
  @ffi.free(argc_ptr)
  let size = @ffi.load32(size_ptr)
  @ffi.free(size_ptr)
  if ret != Success {
    raise ret
  }
  (argc, size)
}

fn args_get_ffi(argv : Int, argv_buf : Int) -> UInt = "wasi_snapshot_preview1" "args_get"

/// Read command-line argument data.
///
/// The size of the array should match that returned by `args_sizes_get`.
///
/// Each argument is **not** `\0` terminated.
///
/// The first argument should be a string containing the "name" of the
/// program. This need not be a usable filesystem path or even file name,
/// and may even be a fixed string. Subsequent arguments are the arguments
/// passed to the program by the user.
pub fn args_get() -> Array[String]!@types.Errno {
  let (argc, size) = args_sizes_get!()
  if argc == 0 {
    return []
  }
  let arg_ptr_ptr = @ffi.malloc(argc * 4)
  let arg_buf = Bytes::new(size)
  let arg_buf_ptr = @ffi.bytes2ptr(arg_buf)
  let ret = args_get_ffi(arg_ptr_ptr, arg_buf_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  if ret != Success {
    @ffi.free(arg_ptr_ptr)
    @ffi.free(arg_buf_ptr)
    raise ret
  }
  let args = []
  for i in 0..<argc {
    let arg_start = @ffi.load32(arg_ptr_ptr + i * 4) - arg_buf_ptr
    let arg_end = if i == argc - 1 {
      size
    } else {
      @ffi.load32(arg_ptr_ptr + (i + 1) * 4) - arg_buf_ptr
    }
    let len = arg_end - arg_start - 1 // remove trailing zero
    let bytes = Bytes::new(len)
    bytes.blit(0, arg_buf, arg_start, len)
    args.push(bytes |> decode_utf8)
  }
  @ffi.free(arg_ptr_ptr)
  @ffi.free(arg_buf_ptr)
  args
}

fn environ_sizes_get_ffi(argc : Int, size : Int) -> UInt = "wasi_snapshot_preview1" "environ_sizes_get"

/// Return environment variable data sizes.
/// 
/// @return `(argc, size)` where `argc` is the number of environment variables and `size` is the size of the buffer needed to store them.
pub fn environ_sizes_get() -> (Int, Int)!@types.Errno {
  let argc_ptr = @ffi.malloc(4)
  let size_ptr = @ffi.malloc(4)
  let ret = environ_sizes_get_ffi(argc_ptr, size_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  let argc = @ffi.load32(argc_ptr)
  let size = @ffi.load32(size_ptr)
  @ffi.free(argc_ptr)
  @ffi.free(size_ptr)
  if ret != Success {
    raise ret
  }
  (argc, size)
}

fn environ_get_ffi(environ : Int, environ_buf : Int) -> UInt = "wasi_snapshot_preview1" "environ_get"

/// Read environment variable data.
/// 
/// The size of the array should match that returned by `environ_sizes_get`.
pub fn environ_get() -> Array[(String, String)]!@types.Errno {
  let (argc, size) = environ_sizes_get!()
  if argc == 0 {
    return []
  }
  let environ_ptr_ptr = @ffi.malloc(argc * 4)
  let environ_buf = Bytes::new(size)
  let environ_buf_ptr = @ffi.bytes2ptr(environ_buf)
  let ret = environ_get_ffi(environ_ptr_ptr, environ_buf_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  if ret != Success {
    @ffi.free(environ_ptr_ptr)
    @ffi.free(environ_buf_ptr)
    raise ret
  }
  let envs = []
  for i in 0..<argc {
    let env_start = @ffi.load32(environ_ptr_ptr + i * 4) - environ_buf_ptr
    let env_end = if i == argc - 1 {
      size
    } else {
      @ffi.load32(environ_ptr_ptr + (i + 1) * 4) - environ_buf_ptr
    }
    let len = env_end - env_start - 1 // remove trailing zero
    let bytes = Bytes::new(len)
    bytes.blit(0, environ_buf, env_start, len)
    let str = bytes |> decode_utf8
    guard let [key, .. as value] = str.split("=").collect()
    envs.push((key, value.iter().collect() |> String::concat(separator="=")))
  }
  @ffi.free(environ_ptr_ptr)
  @ffi.free(environ_buf_ptr)
  envs
}

fn clock_res_get_ffi(clock_id : UInt, resolution : Int) -> UInt = "wasi_snapshot_preview1" "clock_res_get"

/// Return the resolution of a clock.
/// 
/// Implementations are required to provide a non-zero value for supported clocks.
/// For unsupported clocks, return `errno::inval`.
/// 
/// Note: This is similar to `clock_getres` in POSIX.
pub fn clock_res_get(
  clock_id : @types.ClockId
) -> @types.TimeStamp!@types.Errno {
  let resolution_ptr = @ffi.malloc(8)
  let ret = clock_res_get_ffi(clock_id.value(), resolution_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  let resolution = @ffi.load64(resolution_ptr).reinterpret_as_uint64()
  @ffi.free(resolution_ptr)
  if ret != Success {
    raise ret
  }
  resolution
}

fn clock_time_get_ffi(clock_id : UInt, precision : UInt64, time : Int) -> UInt = "wasi_snapshot_preview1" "clock_time_get"

/// Return the time value of a clock
/// 
/// Note: This is similar to `clock_gettime` in POSIX.
pub fn clock_time_get(
  clock_id : @types.ClockId,
  precision : @types.TimeStamp
) -> @types.TimeStamp!@types.Errno {
  let time_ptr = @ffi.malloc(8)
  let ret = clock_time_get_ffi(clock_id.value(), precision._, time_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  let time = @ffi.load64(time_ptr).reinterpret_as_uint64()
  @ffi.free(time_ptr)
  if ret != Success {
    raise ret
  }
  time
}

fn fd_write_ffi(fd : Int, iovs : Int, iovs_len : Int, nwritten : Int) -> UInt = "wasi_snapshot_preview1" "fd_write"

/// Write to a file descriptor.
/// 
/// Note: This is similar to `writev` in POSIX.
/// 
/// Like POSIX, any calls of `write` (and other functions to read or write)
/// for a regular file by other threads in the WASI process should not be
/// interleaved while `write` is executed.
/// 
/// Note: it may write less than demanded.
pub fn fd_write(
  fd : @types.Fd,
  contents : Array[Bytes]
) -> @types.Size!@types.Errno {
  let iovs_len = contents.length()
  let iovs_ptr = @ffi.malloc(iovs_len * 8)
  for i, byte in contents {
    let ptr = @ffi.bytes2ptr(byte)
    @ffi.store32(iovs_ptr + i * 8, ptr)
    @ffi.store32(iovs_ptr + i * 8 + 4, byte.length())
    @ffi.free(ptr)
  }
  let nwritten_ptr = @ffi.malloc(4)
  let ret = fd_write_ffi(fd._, iovs_ptr, iovs_len, nwritten_ptr)
  let ret = @types.Errno::from_value(ret).unwrap()
  let nwritten = @ffi.load32(nwritten_ptr).reinterpret_as_uint()
  @ffi.free(nwritten_ptr)
  @ffi.free(iovs_ptr)
  ignore(contents)
  if ret != Success {
    raise ret
  }
  nwritten
}

fn proc_exit_ffi(rval : UInt) = "wasi_snapshot_preview1" "proc_exit"

/// Terminate the process normally. An exit code of 0 indicates successful
/// termination of the program. The meanings of other values is dependent on
/// the environment.
/// 
/// Note: the accepted range may depend on the runtime, meaning that it may
/// become an error to return a value outside the accepted range of exit codes,
/// making the actual error code environment-dependent.
pub fn proc_exit(rval : UInt) -> Unit {
  proc_exit_ffi(rval)
}

fn random_get_ffi(buf : Int, buf_len : Int) -> UInt = "wasi_snapshot_preview1" "random_get"

/// Write high-quality random data into a buffer.
/// 
/// This function blocks when the implementaiton is unable to immediately
/// provide sufficient high-quality random data.
/// 
/// This function may execute slowly, so when larget mounts of random data are
/// required, it's advisable to use this function to seed a pseudo-random
/// number generator, rather than to provide the random data directly.
pub fn random_get(buf : Bytes) -> Unit!@types.Errno {
  let buf_len = buf.length()
  let buf_ptr = @ffi.bytes2ptr(buf)
  let ret = random_get_ffi(buf_ptr, buf_len)
  let ret = @types.Errno::from_value(ret).unwrap()
  @ffi.free(buf_ptr)
  if ret != Success {
    raise ret
  }
}
