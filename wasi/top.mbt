fn args_sizes_get_ffi(argc : Int, size : Int) -> UInt = "wasi_snapshot_preview1" "args_sizes_get"

/// Return command-line argument data sizes.
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
