fn args_sizes_get_ffi(argc : Int, size : Int) -> UInt = "wasi_snapshot_preview1" "args_sizes_get"

/// Return command-line argument data sizes.
/// 
/// @return Returns the number of arguments and the size of the argument string data, or an error.
pub fn args_sizes_get() -> (Int, Int)!Errno {
  let argc_ptr = @ffi.malloc(4)
  let size_ptr = @ffi.malloc(4)
  let ret = args_sizes_get_ffi(argc_ptr, size_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
pub fn args_get() -> Array[String]!Errno {
  let (argc, size) = args_sizes_get!()
  if argc == 0 {
    return []
  }
  let arg_ptr_ptr = @ffi.malloc(argc * 4)
  let arg_buf = Bytes::new(size)
  let arg_buf_ptr = @ffi.bytes2ptr(arg_buf)
  let ret = args_get_ffi(arg_ptr_ptr, arg_buf_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
/// @return Returns the number of environment variables arguments and the size of the environment variable data.
pub fn environ_sizes_get() -> (Int, Int)!Errno {
  let argc_ptr = @ffi.malloc(4)
  let size_ptr = @ffi.malloc(4)
  let ret = environ_sizes_get_ffi(argc_ptr, size_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
pub fn environ_get() -> Array[(String, String)]!Errno {
  let (argc, size) = environ_sizes_get!()
  if argc == 0 {
    return []
  }
  let environ_ptr_ptr = @ffi.malloc(argc * 4)
  let environ_buf = Bytes::new(size)
  let environ_buf_ptr = @ffi.bytes2ptr(environ_buf)
  let ret = environ_get_ffi(environ_ptr_ptr, environ_buf_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
/// 
/// @param `self` The clock for which to return the resolution.  
/// @return The resolution of the clock, or an error if one happened.
pub fn clock_res_get(self : ClockId) -> TimeStamp!Errno {
  let resolution_ptr = @ffi.malloc(8)
  let ret = clock_res_get_ffi(self.value(), resolution_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
/// 
/// @param `self` The clodk for which to return the time.  
/// @param `precision` The maximum lag (exclusive) that the returned time value may have, compared to its actual value.  
/// @return The time value of the clock.
pub fn clock_time_get(self : ClockId, precision : TimeStamp) -> TimeStamp!Errno {
  let time_ptr = @ffi.malloc(8)
  let ret = clock_time_get_ffi(self.value(), precision._, time_ptr)
  let ret = Errno::from_value(ret).unwrap()
  let time = @ffi.load64(time_ptr).reinterpret_as_uint64()
  @ffi.free(time_ptr)
  if ret != Success {
    raise ret
  }
  time
}

fn fd_advise_ffi(
  fd : Int,
  offset : UInt64,
  len : UInt64,
  advice : UInt
) -> UInt = "wasi_snapshot_preview1" "fd_advise"

/// Provide file advisory information on a file ddescriptor
/// 
/// Note: This is similar to `posix_fadvise` in POSIX.
/// 
/// @param `offset` The offset within the file to which the advisory applies.  
/// @param `len` The length of the region to which the advisory applies.  
/// @param `advice` The advice.
pub fn fd_advise(
  self : Fd,
  offset : FileSize,
  len : FileSize,
  advice : Advice
) -> Unit!Errno {
  let ret = fd_advise_ffi(self._, offset._, len._, advice.value())
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_allocate_ffi(fd : Int, offset : UInt64, len : UInt64) -> UInt = "wasi_snapshot_preview1" "fd_allocate"

/// Force the allocaiton of space in a file.
/// 
/// Note: This is similar to `posix_fallocate` in POSIX.
/// 
/// @param `offset` The offset at which to start allocating.  
/// @param `len` The length of the area that is allocated.  
/// @return The error code.
pub fn fd_allocate(self : Fd, offset : FileSize, len : FileSize) -> Unit!Errno {
  let ret = fd_allocate_ffi(self._, offset._, len._)
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_close_ffi(fd : Int) -> UInt = "wasi_snapshot_preview1" "fd_close"

/// Close a file descriptor.
/// 
/// Note: This is similar to `close` in POSIX.
pub fn fd_close(self : Fd) -> Unit!Errno {
  let ret = fd_close_ffi(self._)
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_datasync_ffi(fd : Int) -> UInt = "wasi_snapshot_preview1" "fd_datasync"

/// Synchronize the data of a file to disk.
/// 
/// Note: This is similar to `fdatasync` in POSIX.
pub fn fd_datasync(self : Fd) -> Unit!Errno {
  let ret = fd_datasync_ffi(self._)
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_fdstat_get_ffi(fd : Int, buf : Int) -> UInt = "wasi_snapshot_preview1" "fd_fdstat_get"

/// Get the attributes of a file descriptor.
/// 
/// Note: This returns similar flags to `fcntl(fd, F_GETFL)` in POSIX, as well as additional fields.
pub fn fd_fdstat_get(self : Fd) -> FdStat!Errno {
  let buf_ptr = @ffi.malloc(24)
  let ret = fd_fdstat_get_ffi(self._, buf_ptr)
  let ret = Errno::from_value(ret).unwrap()
  let fs_filetype : FileType = @ffi.load8_u(buf_ptr)
    |> FileType::from_value
    |> Option::unwrap
  let fs_flags : FdFlag = @ffi.load16_u(buf_ptr + 2).reinterpret_as_uint()
  let fs_rights_base : Right = @ffi.load64(buf_ptr + 8).reinterpret_as_uint64()
  let fs_rights_inheriting : Right = @ffi.load64(buf_ptr + 16).reinterpret_as_uint64()
  let buf = FdStat::{
    fs_filetype,
    fs_flags,
    fs_rights_base,
    fs_rights_inheriting,
  }
  @ffi.free(buf_ptr)
  if ret != Success {
    raise ret
  }
  buf
}

fn fd_fdstat_set_flags_ffi(fd : Int, flags : UInt) -> UInt = "wasi_snapshot_preview1" "fd_fdstat_set_flags"

/// Adjust the flags associated with a file descriptor.
/// 
/// Note: This is similar to `fcntl(fd, F_SETFL, flags)` in POSIX.
/// 
/// @param `flags` The desired values of the file descriptor flags.
pub fn fd_fdstat_set_flags(self : Fd, flags : FdFlag) -> Unit!Errno {
  let ret = fd_fdstat_set_flags_ffi(self._, flags._)
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_fdstat_set_rights_ffi(
  fd : Int,
  fs_rights_base : UInt64,
  fs_rights_inheriting : UInt64
) -> UInt = "wasi_snapshot_preview1" "fd_fdstat_set_rights"

/// Adjust the rights associated with a file descriptor.
/// 
/// This can only be used to remove rights, and returns `errno::notcapable` if called in a way that would attempt to add rights.
/// 
/// @param `fs_rights_base` The desired rights of the file descriptor.
pub fn fd_fdstat_set_rights(
  self : Fd,
  fs_rights_base : Right,
  fs_rights_inheriting : Right
) -> Unit!Errno {
  let ret = fd_fdstat_set_rights_ffi(
    self._,
    fs_rights_base._,
    fs_rights_inheriting._,
  )
  let ret = Errno::from_value(ret).unwrap()
  if ret != Success {
    raise ret
  }
}

fn fd_filestat_get_ffi(fd : Int, buf : Int) -> UInt = "wasi_snapshot_preview1" "fd_filestat_get"

/// Return the attributes of an open file
pub fn fd_filestat_get(self : Fd) -> FileStat!Errno {
  let buf_ptr = @ffi.malloc(24)
  let ret = fd_filestat_get_ffi(self._, buf_ptr)
  let ret = Errno::from_value(ret).unwrap()
  let dev : Device = @ffi.load64(buf_ptr).reinterpret_as_uint64()
  let ino : Inode = @ffi.load64(buf_ptr + 8).reinterpret_as_uint64()
  let filetype : FileType = @ffi.load8_u(buf_ptr + 16)
    |> FileType::from_value
    |> Option::unwrap
  let nlink : LinkCount = @ffi.load64(buf_ptr + 24).reinterpret_as_uint64()
  let size : FileSize = @ffi.load64(buf_ptr + 32).reinterpret_as_uint64()
  let atim : TimeStamp = @ffi.load64(buf_ptr + 40).reinterpret_as_uint64()
  let mtim : TimeStamp = @ffi.load64(buf_ptr + 48).reinterpret_as_uint64()
  let ctim : TimeStamp = @ffi.load64(buf_ptr + 56).reinterpret_as_uint64()
  let buf = FileStat::{ dev, ino, filetype, nlink, size, atim, mtim, ctim }
  @ffi.free(buf_ptr)
  if ret != Success {
    raise ret
  }
  buf
}

fn fd_read_ffi(fd : Int, iovs : Int, iovs_len : Int, nread : Int) -> UInt = "wasi_snapshot_preview1" "fd_read"

/// Read from a file descriptor.
/// 
/// Note: This is similar to `readv` in POSIX.
pub fn fd_read(self : Fd, iovs : Array[Bytes]) -> Size!Errno {
  let iovs_len = iovs.length()
  let iovs_ptr = @ffi.malloc(iovs_len * 8)
  for i, byte in iovs {
    let ptr = @ffi.bytes2ptr(byte)
    @ffi.store32(iovs_ptr + i * 8, ptr)
    @ffi.store32(iovs_ptr + i * 8 + 4, byte.length())
    @ffi.free(ptr)
  }
  let nread_ptr = @ffi.malloc(4)
  let ret = fd_read_ffi(self._, iovs_ptr, iovs_len, nread_ptr)
  let ret = Errno::from_value(ret).unwrap()
  let nread = @ffi.load32(nread_ptr).reinterpret_as_uint()
  @ffi.free(nread_ptr)
  @ffi.free(iovs_ptr)
  if ret != Success {
    raise ret
  }
  ignore(iovs)
  nread
}

fn fd_readdir_ffi(
  fd : Int,
  buf : Int,
  buf_len : Int,
  cookie : UInt64,
  buf_used : Int
) -> UInt = "wasi_snapshot_preview1" "fd_readdir"

/// Read directory entries from a directory.
/// When successful, the contents of the output buffer consist of a sequence of
/// directory entries. Each directory entry consists of a `dirent` object,
/// followed by `dirent::d_namlen` bytes holding the name of the directory
/// entry.
///
/// This function fills the output buffer as much as possible, potentially
/// truncating the last directory entry. This allows the caller to grow its
/// read buffer size in case it's too small to fit a single large directory
/// entry, or skip the oversized directory entry.
///
/// Entries for the special `.` and `..` directory entries are included in the
/// sequence.
/// 
/// @param `cookie`: The location within the directory to start reading.
/// @param `size`: The buffer used to read.
/// @return The entries untruncated and whether there's still other entries.
pub fn fd_readdir(
  self : Fd,
  ~cookie : DirCookie = DirCookie(0),
  ~buffer : Bytes = Bytes::new(4096)
) -> (Array[(String, DirEnt)], Bool)!Errno {
  let buf_len = buffer.length()
  let buf_ptr = @ffi.bytes2ptr(buffer)
  let buf_used_ptr = @ffi.malloc(4)
  let ret = fd_readdir_ffi(self._, buf_ptr, buf_len, cookie._, buf_used_ptr)
  let ret = Errno::from_value(ret).unwrap()
  let buf_used = @ffi.load32(buf_used_ptr)
  @ffi.free(buf_used_ptr)
  @ffi.free(buf_ptr)
  if ret != Success {
    raise ret
  }
  let entries = []
  for i = 0; i < buf_used; {
    if i + 24 > buf_used {
      // truncated
      break (entries, true)
    }
    let d_next : DirCookie = @ffi.load64(buf_ptr + i).reinterpret_as_uint64()
    let d_ino : Inode = @ffi.load64(buf_ptr + i + 8).reinterpret_as_uint64()
    let namlen = @ffi.load32(buf_ptr + i + 16)
    let d_namlen : DirNamlen = namlen.reinterpret_as_uint()
    let d_type : FileType = @ffi.load8_u(buf_ptr + i + 20)
      |> FileType::from_value
      |> Option::unwrap
    if i + 24 + d_namlen._.reinterpret_as_int() > buf_used {
      // truncated
      break (entries, true)
    }
    let string = Bytes::new(namlen)
    string.blit(0, buffer, i + 24, namlen)
    entries.push(
      (string |> decode_utf8, DirEnt::{ d_next, d_ino, d_namlen, d_type }),
    )
    continue i + 24 + namlen
  } else {
    (entries, buf_used == buf_len)
  }
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
pub fn fd_write(self : Fd, contents : Array[Bytes]) -> Size!Errno {
  let iovs_len = contents.length()
  let iovs_ptr = @ffi.malloc(iovs_len * 8)
  for i, byte in contents {
    let ptr = @ffi.bytes2ptr(byte)
    @ffi.store32(iovs_ptr + i * 8, ptr)
    @ffi.store32(iovs_ptr + i * 8 + 4, byte.length())
    @ffi.free(ptr)
  }
  let nwritten_ptr = @ffi.malloc(4)
  let ret = fd_write_ffi(self._, iovs_ptr, iovs_len, nwritten_ptr)
  let ret = Errno::from_value(ret).unwrap()
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
pub fn random_get(buf : Bytes) -> Unit!Errno {
  let buf_len = buf.length()
  let buf_ptr = @ffi.bytes2ptr(buf)
  let ret = random_get_ffi(buf_ptr, buf_len)
  let ret = Errno::from_value(ret).unwrap()
  @ffi.free(buf_ptr)
  if ret != Success {
    raise ret
  }
}
