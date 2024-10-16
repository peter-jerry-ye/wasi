# WASI

⚠️ It's a complete rewrite since 0.17.0

WASI Preview 1 implementation for MoonBit

- [x] Wasm Backend
- [ ] Wasm-GC Backend

## Implemented functions

- [x] `args_get`
- [x] `args_sizes_get`
- [x] `environ_get`
- [x] `environ_sizes_get`
- [x] `clock_res_get`
- [x] `clock_time_get`
- [x] `fd_advise`
- [x] `fd_allocate`
- [x] `fd_close`
- [x] `fd_datasync`
- [ ] `fd_fdstat_get`
- [ ] `fd_fdstat_set_flags`
- [ ] `fd_fdstat_set_rights`
- [ ] `fd_filestat_get`
- [ ] `fd_filestat_set_size`
- [ ] `fd_filestat_set_times`
- [ ] `fd_pread`
- [ ] `fd_prestat_get`
- [ ] `fd_prestat_dir_name`
- [ ] `fd_pwrite`
- [ ] `fd_read`
- [ ] `fd_readdir`
- [ ] `fd_renumber`
- [ ] `fd_seek`
- [ ] `fd_sync`
- [ ] `fd_tell`
- [x] `fd_write`
- [ ] `path_create_directory`
- [ ] `path_filestat_get`
- [ ] `path_filestat_set_times`
- [ ] `path_link`
- [ ] `path_open`
- [ ] `path_readlink`
- [ ] `path_remove_directory`
- [ ] `path_rename`
- [ ] `path_symlink`
- [ ] `path_unlink_file`
- [ ] `poll_oneoff`
- [x] `proc_exit`
- [ ] `proc_raise`
- [ ] `sched_yield`
- [x] `random_get`
- [ ] `sock_accept`
- [ ] `sock_recv`
- [ ] `sock_send`
- [ ] `sock_shutdown`

## Develop

- Testing: `deno task test:build && deno task test`