pub type Size UInt derive(Eq, Show)

/// Non-negative file size or length of a region within a file.
pub type FileSize UInt64 derive(Eq, Show)

/// Timestamp in nanoseconds.
pub type TimeStamp UInt64 derive(Eq, Show)

/// Identifiers for clocks.
/// 
/// - Realtime: The clock measuring real time. Time value zero corresponds with 1970-01-01T00:00:00Z.
/// - Monotonic: The store-wide monotonic clock, which is defined as a clock measuring
/// real time, whose value cannot be adjusted and which cannot have negative
/// clock jumps. The epoch of this clock is undefined. The absolute time
/// value of this clock therefore has no meaning.
/// - ProcessCPUTimeId: The CPU-time clock associated with the current process.
/// - ThreadCPUTimeId: The CPU-time clock associated with the current thread.
pub enum ClockId {
  RealTime
  Monotonic
  ProcessCPUTimeId
  ThreadCPUTimeId
} derive(Eq, Show)

pub fn value(self : ClockId) -> UInt {
  match self {
    RealTime => 0
    Monotonic => 1
    ProcessCPUTimeId => 2
    ThreadCPUTimeId => 3
  }
}

pub fn ClockId::from_value(value : UInt) -> ClockId? {
  match value {
    0 => Some(RealTime)
    1 => Some(Monotonic)
    2 => Some(ProcessCPUTimeId)
    3 => Some(ThreadCPUTimeId)
    _ => None
  }
}

/// Error codes returned by functions.
/// Not all of these error codes are returned by the functions provided by this
/// API; some are used in higher-level library layers, and others are provided
/// merely for alignment with POSIX.
/// 
/// See : https://github.com/WebAssembly/WASI/blob/main/legacy/preview1/docs.md#-errno-variant
pub type! Errno {
  Success
  TooBig
  Acces
  Addrinuse
  Addrnotavail
  Afnosupport
  Again
  Already
  Badf
  Badmsg
  Busy
  Canceled
  Connaborted
  Connrefused
  Connreset
  Deadlock
  Destaddrreq
  Dom
  Dquot
  Exist
  Fault
  Fbig
  Hostunreach
  Idrm
  Ilseq
  Inprogress
  Intr
  Inval
  IO
  Isconn
  Isdir
  Loop
  Mfile
  Mlink
  Msgsize
  Multihop
  Nametoolong
  Netdown
  Netreset
  Netunreach
  Nfile
  Nobufs
  Nodev
  Noent
  Noexec
  Nolck
  Nolink
  Nomem
  Nomsg
  Noprotoopt
  Nospc
  Nosys
  Notconn
  Notdir
  Notempty
  Notrecoverable
  Notsock
  Notsup
  Notty
  Nxio
  Overflow
  Ownerdead
  Perm
  Pipe
  Proto
  Protonosupport
  Prototype
  Range
  Rofs
  Spipe
  Srch
  Stale
  Timedout
  Txtbsy
  Xdev
  Notcapable
} derive(Eq, Show)

pub fn value(self : Errno) -> UInt {
  match self {
    Success => 0
    TooBig => 1
    Acces => 2
    Addrinuse => 3
    Addrnotavail => 4
    Afnosupport => 5
    Again => 6
    Already => 7
    Badf => 8
    Badmsg => 9
    Busy => 10
    Canceled => 11
    Connaborted => 12
    Connrefused => 13
    Connreset => 14
    Deadlock => 15
    Destaddrreq => 16
    Dom => 17
    Dquot => 18
    Exist => 19
    Fault => 20
    Fbig => 21
    Hostunreach => 22
    Idrm => 23
    Ilseq => 24
    Inprogress => 25
    Intr => 26
    Inval => 27
    IO => 28
    Isconn => 29
    Isdir => 30
    Loop => 31
    Mfile => 32
    Mlink => 33
    Msgsize => 34
    Multihop => 35
    Nametoolong => 36
    Netdown => 37
    Netreset => 38
    Netunreach => 39
    Nfile => 40
    Nobufs => 41
    Nodev => 42
    Noent => 43
    Noexec => 44
    Nolck => 45
    Nolink => 46
    Nomem => 47
    Nomsg => 48
    Noprotoopt => 49
    Nospc => 50
    Nosys => 51
    Notconn => 52
    Notdir => 53
    Notempty => 54
    Notrecoverable => 55
    Notsock => 56
    Notsup => 57
    Notty => 58
    Nxio => 59
    Overflow => 60
    Ownerdead => 61
    Perm => 62
    Pipe => 63
    Proto => 64
    Protonosupport => 65
    Prototype => 66
    Range => 67
    Rofs => 68
    Spipe => 69
    Srch => 70
    Stale => 71
    Timedout => 72
    Txtbsy => 73
    Xdev => 74
    Notcapable => 75
  }
}

pub fn Errno::from_value(value : UInt) -> Errno? {
  match value {
    0 => Some(Success)
    1 => Some(TooBig)
    2 => Some(Acces)
    3 => Some(Addrinuse)
    4 => Some(Addrnotavail)
    5 => Some(Afnosupport)
    6 => Some(Again)
    7 => Some(Already)
    8 => Some(Badf)
    9 => Some(Badmsg)
    10 => Some(Busy)
    11 => Some(Canceled)
    12 => Some(Connaborted)
    13 => Some(Connrefused)
    14 => Some(Connreset)
    15 => Some(Deadlock)
    16 => Some(Destaddrreq)
    17 => Some(Dom)
    18 => Some(Dquot)
    19 => Some(Exist)
    20 => Some(Fault)
    21 => Some(Fbig)
    22 => Some(Hostunreach)
    23 => Some(Idrm)
    24 => Some(Ilseq)
    25 => Some(Inprogress)
    26 => Some(Intr)
    27 => Some(Inval)
    28 => Some(IO)
    29 => Some(Isconn)
    30 => Some(Isdir)
    31 => Some(Loop)
    32 => Some(Mfile)
    33 => Some(Mlink)
    34 => Some(Msgsize)
    35 => Some(Multihop)
    36 => Some(Nametoolong)
    37 => Some(Netdown)
    38 => Some(Netreset)
    39 => Some(Netunreach)
    40 => Some(Nfile)
    41 => Some(Nobufs)
    42 => Some(Nodev)
    43 => Some(Noent)
    44 => Some(Noexec)
    45 => Some(Nolck)
    46 => Some(Nolink)
    47 => Some(Nomem)
    48 => Some(Nomsg)
    49 => Some(Noprotoopt)
    50 => Some(Nospc)
    51 => Some(Nosys)
    52 => Some(Notconn)
    53 => Some(Notdir)
    54 => Some(Notempty)
    55 => Some(Notrecoverable)
    56 => Some(Notsock)
    57 => Some(Notsup)
    58 => Some(Notty)
    59 => Some(Nxio)
    60 => Some(Overflow)
    61 => Some(Ownerdead)
    62 => Some(Perm)
    63 => Some(Pipe)
    64 => Some(Proto)
    65 => Some(Protonosupport)
    66 => Some(Prototype)
    67 => Some(Range)
    68 => Some(Rofs)
    69 => Some(Spipe)
    70 => Some(Srch)
    71 => Some(Stale)
    72 => Some(Timedout)
    73 => Some(Txtbsy)
    74 => Some(Xdev)
    75 => Some(Notcapable)
    _ => None
  }
}

test "errno" {
  for i in 0U..<76 {
    let errno = Errno::from_value(i)
    assert_eq!(errno.unwrap().value(), i)
  }
}

///  File descriptor rights, determining which actions may be performed.
pub type Right UInt64 derive(Eq, Show)

pub fn Right::new() -> Right {
  0
}

///  File descriptor rights, determining which actions may be performed.
pub enum Rights {
  Fd_datasync
  Fd_read
  Fd_seek
  Fd_fdstat_set_flags
  Fd_sync
  Fd_tell
  Fd_write
  Fd_advice
  Fd_allocate
  Path_create_directory
  Path_create_file
  Path_link_source
  Path_link_target
  Path_open
  Fd_readdir
  Path_readlink
  Path_rename_source
  Path_rename_target
  Path_filestat_get
  Path_filestat_set_size
  Path_filestat_set_times
  Fd_filestat_get
  Fd_filestat_set_size
  Fd_filestat_set_times
  Path_symlink
  Path_remove_directory
  Path_unlink_file
  Poll_fd_readwrite
  Sock_shutdown
  Sock_accept
} derive(Eq, Show)

pub fn value(self : Rights) -> UInt64 {
  match self {
    Fd_datasync => 1UL << 1
    Fd_read => 1UL << 2
    Fd_seek => 1UL << 3
    Fd_fdstat_set_flags => 1UL << 4
    Fd_sync => 1UL << 5
    Fd_tell => 1UL << 6
    Fd_write => 1UL << 7
    Fd_advice => 1UL << 8
    Fd_allocate => 1UL << 9
    Path_create_directory => 1UL << 10
    Path_create_file => 1UL << 11
    Path_link_source => 1UL << 12
    Path_link_target => 1UL << 13
    Path_open => 1UL << 14
    Fd_readdir => 1UL << 15
    Path_readlink => 1UL << 16
    Path_rename_source => 1UL << 17
    Path_rename_target => 1UL << 18
    Path_filestat_get => 1UL << 19
    Path_filestat_set_size => 1UL << 20
    Path_filestat_set_times => 1UL << 21
    Fd_filestat_get => 1UL << 22
    Fd_filestat_set_size => 1UL << 23
    Fd_filestat_set_times => 1UL << 24
    Path_symlink => 1UL << 25
    Path_remove_directory => 1UL << 26
    Path_unlink_file => 1UL << 27
    Poll_fd_readwrite => 1UL << 28
    Sock_shutdown => 1UL << 29
    Sock_accept => 1UL << 30
  }
}

pub fn set(self : Right, right : Rights) -> Right {
  self._ | right.value()
}

pub fn unset(self : Right, right : Rights) -> Right {
  self._ & (right.value() ^ 0)
}

pub fn is_set(self : Right, right : Rights) -> Bool {
  (self._ & right.value()) != 0
}

/// A file descriptor handle
pub type Fd Int derive(Eq, Show)

/// A region of memory for scatter/gather reads.
/// 
/// - `buf`: The address of the buffer to be filled.
/// - `buf_len`: The length of the buffer to be filled.
pub struct IOVec {
  buf : Int
  buf_len : Size
} derive(Eq, Show)

/// A region of memory for scatter/gather writes.
/// 
/// - `buf`: The address of the buffer to be written.
/// - `buf_len`: The length of the buffer to be written.
pub struct CIOVec {
  buf : Int
  buf_len : Size
} derive(Eq, Show)

/// Relative offset within a file.
pub type FileDelta Int64 derive(Eq, Show)

/// The position relative to which to set the offset of the file descriptor
pub enum Whence {
  Set
  Cur
  End
} derive(Eq, Show)

pub fn value(self : Whence) -> Int {
  match self {
    Set => 0
    Cur => 1
    End => 2
  }
}

pub fn Whence::from_value(value : Int) -> Whence? {
  match value {
    0 => Some(Set)
    1 => Some(Cur)
    2 => Some(End)
    _ => None
  }
}

/// A reference to the offset of a directory entry.
/// 
/// The value 0 signifies the start of the directory.
pub type DirCookie UInt64 derive(Eq, Show)

/// The type for the `dirent::d_namlen` field of `dirent` struct.
pub type DirNamlen UInt derive(Eq, Show)

/// File serial number that is unique within its file system.
pub type Inode UInt64 derive(Eq, Show)

/// The type of a file descriptor or file.
/// 
/// - Unknown: The type of the file descriptor or file is unknown or is different from any of the other types specified.
/// - Block_device: The file descriptor or file refers to a block device inode.
/// - Character_device: The file descriptor or file refers to a character device inode.
/// - Directory: The file descriptor or file refers to a directory inode.
/// - Regular_file: The file descriptor or file refers to a regular file inode.
/// - Socket_dgram: The file descriptor or file refers to a datagram socket.
/// - Socket_stream: The file descriptor or file refers to a byte-stream socket.
/// - Symbolic_link: The file refers to a symbolic link inode.
pub enum FileType {
  Unknown
  Block_device
  Character_device
  Directory
  Regular_file
  Socket_dgram
  Socket_stream
  Symbolic_link
} derive(Eq, Show)

pub fn value(self : FileType) -> Int {
  match self {
    Unknown => 0
    Block_device => 1
    Character_device => 2
    Directory => 3
    Regular_file => 4
    Socket_dgram => 5
    Socket_stream => 6
    Symbolic_link => 7
  }
}

pub fn FileType::from_value(value : Int) -> FileType? {
  match value {
    0 => Some(Unknown)
    1 => Some(Block_device)
    2 => Some(Character_device)
    3 => Some(Directory)
    4 => Some(Regular_file)
    5 => Some(Socket_dgram)
    6 => Some(Socket_stream)
    7 => Some(Symbolic_link)
    _ => None
  }
}

/// A directory entry.
/// 
/// - `d_next`: The offset of the next directory entry stored in the buffer.
/// - `d_ino`: The serial number of the file referred to by this directory entry.
/// - `d_namlen`: The length of the name of the directory entry.
/// - `d_type`: The type of the file referred to by this directory entry.
pub struct Dirent {
  d_next : DirCookie
  d_ino : Inode
  d_namlen : DirNamlen
  d_type : FileType
} derive(Eq, Show)

/// File or memory access pattern advisory information.
/// 
/// - Normal: The application has no advice to give on its behavior with respect to the specified data.
/// - Sequential: The application expects to access the specified data sequentially from lower offsets to higher offsets.
/// - Random: The application expects to access the specified data in a random order.
/// - Willneed: The application expects to access the specified data in the near future.
/// - Dontneed: The application expects that it will not access the specified data in the near future.
/// - Noreuse: The application expects to access the specified data once and then not reuse it afterwards.
pub enum Advice {
  Normal
  Sequential
  Random
  Willneed
  Dontneed
  Noreuse
} derive(Eq, Show)

pub fn value(self : Advice) -> UInt {
  match self {
    Normal => 0
    Sequential => 1
    Random => 2
    Willneed => 3
    Dontneed => 4
    Noreuse => 5
  }
}

pub fn Advice::from_value(value : UInt) -> Advice? {
  match value {
    0 => Some(Normal)
    1 => Some(Sequential)
    2 => Some(Random)
    3 => Some(Willneed)
    4 => Some(Dontneed)
    5 => Some(Noreuse)
    _ => None
  }
}

/// File descriptor flag.
pub type FdFlag UInt derive(Eq, Show)

pub fn FdFlag::new() -> FdFlag {
  0
}

/// File descriptor flags.
/// 
/// - Append: Append mode: Data written to the file is always appended to the file's end.
/// - Dsync: Write according to synchronized I/O data integrity completion. Only the data stored in the file is synchronized.
/// - Nonblock: Non-blocking mode.
/// - Rsync: Synchronized read I/O operations.
/// - Sync: Write according to synchronized I/O file integrity completion. In addition to synchronizing the data stored in the file, the implementation may also synchronously update the file's metadata.
pub enum FdFlags {
  Append
  Dsync
  Nonblock
  Rsync
  Sync
} derive(Eq, Show)

pub fn value(self : FdFlags) -> UInt {
  match self {
    Append => 1
    Dsync => 2
    Nonblock => 4
    Rsync => 8
    Sync => 16
  }
}

pub fn set(self : FdFlag, flag : FdFlags) -> FdFlag {
  self._ | flag.value()
}

pub fn unset(self : FdFlag, flag : FdFlags) -> FdFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : FdFlag, flag : FdFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// File descriptor attributes.
/// 
/// - `fs_filetype`: File type.
/// - `fs_flags`: File descriptor flags.
/// - `fs_rights_base`: Rights that apply to this file descriptor.
/// - `fs_rights_inheriting`: Maximum set of rights that may be installed on new file descriptors that are created through this file descriptor, e.g., through `path_open`.
pub struct FdStat {
  fs_filetype : FileType
  fs_flags : FdFlags
  fs_rights_base : Right
  fs_rights_inheriting : Right
} derive(Eq, Show)

/// Identifier for a device containing a file system. Can be used in combination
/// with `inode` to uniquely identify a file or directory in the filesystem.
pub type Device UInt64 derive(Eq, Show)

/// Which file time attributes to adjust
pub type FstFlag UInt derive(Eq, Show)

pub fn FstFlag::new() -> FstFlag {
  0
}

/// Which file time attributes to adjust
/// 
/// - Atim: Adjust the last access timestamp to the value stored in `filestat::atim`.
/// - Atim_now: Adjust the last access timestamp to the time of clock `clockid::realtime`.
/// - Mtim: Adjust the last modification timestamp to the value stored in `filestat::mtim`.
/// - Mtim_now: Adjust the last modification timestamp to the time of clock `clockid::realtime`.
pub enum FstFlags {
  Atim
  Atim_now
  Mtim
  Mtim_now
} derive(Eq, Show)

pub fn value(self : FstFlags) -> UInt {
  match self {
    Atim => 1
    Atim_now => 2
    Mtim => 4
    Mtim_now => 8
  }
}

pub fn set(self : FstFlag, flag : FstFlags) -> FstFlag {
  self._ | flag.value()
}

pub fn unset(self : FstFlag, flag : FstFlags) -> FstFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : FstFlag, flag : FstFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Flags dermining the method of how paths are resolved.
pub type LookupFlag UInt derive(Eq, Show)

pub fn LookupFlag::new() -> LookupFlag {
  0
}

pub enum LookupFlags {
  Symlink_follow
} derive(Eq, Show)

pub fn value(self : LookupFlags) -> UInt {
  match self {
    Symlink_follow => 1
  }
}

pub fn set(self : LookupFlag, flag : LookupFlags) -> LookupFlag {
  self._ | flag.value()
}

pub fn unset(self : LookupFlag, flag : LookupFlags) -> LookupFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : LookupFlag, flag : LookupFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Open flags used by `path_open`.
pub type OpenFlag UInt derive(Eq, Show)

pub fn OpenFlag::new() -> OpenFlag {
  0
}

/// Open flags used by `path_open`.
/// 
/// - Create: Create the file if it does not exist.
/// - Directory: Fail if not a directory.
/// - Excl: Fail if the file already exists.
/// - Trunc: Truncate the file to size 0.
pub enum OpenFlags {
  Create
  Directory
  Excl
  Trunc
} derive(Eq, Show)

pub fn value(self : OpenFlags) -> UInt {
  match self {
    Create => 1
    Directory => 2
    Excl => 4
    Trunc => 8
  }
}

pub fn set(self : OpenFlag, flag : OpenFlags) -> OpenFlag {
  self._ | flag.value()
}

pub fn unset(self : OpenFlag, flag : OpenFlags) -> OpenFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : OpenFlag, flag : OpenFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Number of hard links to an inode.
pub type LinkCount UInt64 derive(Eq, Show)

/// File attributes.
/// 
/// - `dev`: Device ID of device containing the file.
/// - `ino`: File serial number.
/// - `filetype`: File type.
/// - `nlink`: Number of hard links to the file.
/// - `size`: For regular files, the file size in bytes. For symbolic links, the length in bytes of the pathname contained in the symbolic link.
/// - `atim`: Last data access timestamp. This can be 0 if the underlying platform doesn't provide suitable timestamp for this file.
/// - `mtim`: Last data modification timestamp. This can be 0 if the underlying platform doesn't provide suitable timestamp for this file.
/// - `ctim`: Last file status change timestamp. This can be 0 if the underlying platform doesn't provide suitable timestamp for this file.
pub struct FileStat {
  dev : Device
  ino : Inode
  filetype : FileType
  nlink : LinkCount
  size : FileSize
  atim : TimeStamp
  mtim : TimeStamp
  ctim : TimeStamp
}

/// User-provided value that may be attached to objects that is retained when
/// extracted from the implementation.
pub type Userdata UInt64 derive(Eq, Show)

/// Type of a subscription to an event or its occurrence.
/// 
/// - Clock: The time value of clock `subscription_clock::id` has reached timestamp `subscription_clock::timeout`.
/// - Fd_read: File descriptor `subscription_fd_readwrite::file_descriptor` has data available for reading. This event always triggers for regular files.
/// - Fd_write: File descriptor `subscription_fd_readwrite::file_descriptor` has capacity available for writing. This event always triggers for regular files.
pub enum EventType {
  Clock
  Fd_read
  Fd_write
} derive(Eq, Show)

/// The state of the file descriptor subscribed to with `eventtype::fd_read` or `eventtype::fd_write`.
pub type EventRWFlag UInt derive(Eq, Show)

pub fn EventRWFlag::new() -> EventRWFlag {
  0
}

/// The state of the file descriptor subscribed to with `eventtype::fd_read` or `eventtype::fd_write`.
/// 
/// - Fd_readwrite_hangup: The peer of this socket has closed or disconnected.
pub enum EventRWFlags {
  Fd_readwrite_hangup
} derive(Eq, Show)

pub fn value(self : EventRWFlags) -> UInt {
  match self {
    Fd_readwrite_hangup => 1
  }
}

pub fn set(self : EventRWFlag, flag : EventRWFlags) -> EventRWFlag {
  EventRWFlag(self._ | flag.value())
}

pub fn unset(self : EventRWFlag, flag : EventRWFlags) -> EventRWFlag {
  EventRWFlag(self._ & (flag.value() ^ 0))
}

pub fn is_set(self : EventRWFlag, flag : EventRWFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// The contents of an `event` when type is `eventtype::fd_read` or
/// `eventtype::fd_write`.
/// 
/// - `nbytes`: Number of bytes available for reading or writing.
/// - `flags`: The state of the file descriptor.
pub struct Event_fd_readwrite {
  nbytes : FileSize
  flags : EventRWFlag
} derive(Eq, Show)

/// An event that occurred.
/// 
/// - `userdata`: User-provided value that got attched to `subscription::userdata`.
/// - `error`: If non-zero, an error that occurred while processing the subscription request.
/// - `type_`: The type of the event that occurred.
/// - `fd_readwrite`: The contents of the event, if it is an `eventtype::fd_read` or `eventtype::fd_write`. `eventtype::clock` events ignore this field.
pub struct Event {
  userdata : Userdata
  error : Errno
  type_ : EventType
  fd_readwrite : Event_fd_readwrite
} derive(Eq, Show)

/// Flags determining how to interpret the timestamp provided in `subscription::timeout`.
pub type SubclockFlag UInt derive(Eq, Show)

pub fn SubclockFlag::new() -> SubclockFlag {
  0
}

/// Flags determining how to interpret the timestamp provided in `subscription::timeout`.
/// 
/// - Subscription_clock_abstime: 
///   If set, treat the timestamp provided in
///   `subscription_clock::timeout` as an absolute timestamp of clock
///   `subscription_clock::id`. If clear, treat the timestamp
///   provided in `subscription_clock::timeout` relative to the
///   current time value of clock `subscription_clock::id`.
pub enum SubclockFlags {
  Subscription_clock_abstime
} derive(Eq, Show)

pub fn value(self : SubclockFlags) -> UInt {
  match self {
    Subscription_clock_abstime => 1
  }
}

pub fn set(self : SubclockFlag, flag : SubclockFlags) -> SubclockFlag {
  self._ | flag.value()
}

pub fn unset(self : SubclockFlag, flag : SubclockFlags) -> SubclockFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : SubclockFlag, flag : SubclockFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// The contents of a `subscription` when type is `eventtype::clock`.
/// 
/// - `id`: The clock against which to compare the timestamp.
/// - `timeout`: The absolute or relative timestamp.
/// - `precision`: The amount of time that the implementation may wait additionally to coalesce with other events.
/// - `flags`: Flags specifying whether the timeout is absolute or relative.
pub struct Subscription_clock {
  id : ClockId
  timeout : TimeStamp
  precision : TimeStamp
  flags : SubclockFlag
} derive(Eq, Show)

/// The contents of a `subscription` when type is `eventtype::fd_read` or `eventtype::fd_write`.
/// 
/// - `file_descriptor`: The file descriptor on which to wait for it to become ready for reading or writing.
pub struct Subscription_fd_readwrite {
  file_descriptor : Fd
} derive(Eq, Show)

/// The contents of a `subscription`.
pub enum Subscription_u {
  Clock(Subscription_clock)
  Fd_read(Subscription_fd_readwrite)
  Fd_write(Subscription_fd_readwrite)
} derive(Eq, Show)

/// Subscription to an event.
/// 
/// - `userdata`: User-provided value that is attached to the subscription in the implementaiton and returned through `event::userdata`.
/// - `u`: The type of the event to which to subscribe, and its contents.
pub struct Subscription {
  userdata : Userdata
  u : Subscription_u
} derive(Eq, Show)

/// Exit code generated by a process when exiting.
pub type ExitCode UInt derive(Eq, Show)

/// Signal condition.
/// 
/// - None: No signal. Note that POSIX has special semantics for kill(pid, 0), so this value is reserved.
/// - Hup: Hangup. Action: Terminates the process.
/// - Inte: Terminate interrupt signal. Action: Terminates the process.
/// - Quit: Terminal quit signal. Action: Terminates the process.
/// - Ill: Illegal instruction. Action: Terminates the process.
/// - Trap: Trace/breakpoint trap. Action: Terminates the process.
/// - Abrt: Process abort signal. Action: Terminates the process.
/// - Bus: Access to an undefined portion of a memory object. Action: Terminates the process.
/// - Fpe: Erroneous arithmetic operation. Action: Terminates the process.
/// - Kill: Kill. Action: Terminates the process.
/// - Usr1: User-defined signal 1. Action: Terminates the process.
/// - Segv: Invalid memory reference. Action: Terminates the process.
/// - Usr2: User-defined signal 2. Action: Terminates the process.
/// - Pipe: Write on a pipe with no one to read it. Action: Ignored.
/// - Alrm: Alarm clock. Action: Terminates the process.
/// - Chld: Child process terminated, stopped, or continued. Action: Ignored.
/// - Cont: Continue executing, if stopped. Action: Continues the process.
/// - Stop: Stop executing. Action: Stops the process.
/// - Tstp: Terminal stop signal. Action: Stops the process.
/// - Ttin: Background process attempting read. Action: Stops the process.
/// - Ttou: Background process attempting write. Action: Stops the process.
/// - Urg: High bandwidth data is available at a socket. Action: Ignored.
/// - Xcpu: CPU time limit exceeded. Action: Terminates the process.
/// - Xfsz: File size limit exceeded. Action: Terminates the process.
/// - Vtalrm: Virtual timer expired. Action: Terminates the process.
/// - Prof: Profiling timer expired. Action: Terminates the process.
/// - Winch: Window changed. Action: Ignored.
/// - Poll: I/O possible. Action: Terminates the process.
/// - Pwr: Power failure. Action: Terminates the process.
/// - Sys: Bad system call. Action: Terminates the process.
pub enum Signal {
  None
  Hup
  Inte
  Quit
  Ill
  Trap
  Abrt
  Bus
  Fpe
  Kill
  Usr1
  Segv
  Usr2
  Pipe
  Alrm
  Term
  Chld
  Cont
  Stop
  Tstp
  Ttin
  Ttou
  Urg
  Xcpu
  Xfsz
  Vtalrm
  Prof
  Winch
  Poll
  Pwr
  Sys
}

pub fn value(self : Signal) -> Int {
  match self {
    None => 0
    Hup => 1
    Inte => 2
    Quit => 3
    Ill => 4
    Trap => 5
    Abrt => 6
    Bus => 7
    Fpe => 8
    Kill => 9
    Usr1 => 10
    Segv => 11
    Usr2 => 12
    Pipe => 13
    Alrm => 14
    Term => 15
    Chld => 16
    Cont => 17
    Stop => 18
    Tstp => 19
    Ttin => 20
    Ttou => 21
    Urg => 22
    Xcpu => 23
    Xfsz => 24
    Vtalrm => 25
    Prof => 26
    Winch => 27
    Poll => 28
    Pwr => 29
    Sys => 30
  }
}

pub fn Signal::from_value(value : Int) -> Signal? {
  match value {
    0 => Some(None)
    1 => Some(Hup)
    2 => Some(Inte)
    3 => Some(Quit)
    4 => Some(Ill)
    5 => Some(Trap)
    6 => Some(Abrt)
    7 => Some(Bus)
    8 => Some(Fpe)
    9 => Some(Kill)
    10 => Some(Usr1)
    11 => Some(Segv)
    12 => Some(Usr2)
    13 => Some(Pipe)
    14 => Some(Alrm)
    15 => Some(Term)
    16 => Some(Chld)
    17 => Some(Cont)
    18 => Some(Stop)
    19 => Some(Tstp)
    20 => Some(Ttin)
    21 => Some(Ttou)
    22 => Some(Urg)
    23 => Some(Xcpu)
    24 => Some(Xfsz)
    25 => Some(Vtalrm)
    26 => Some(Prof)
    27 => Some(Winch)
    28 => Some(Poll)
    29 => Some(Pwr)
    30 => Some(Sys)
    _ => None
  }
}

/// Flags provided to `sock_recv`.
pub type RiFlag UInt derive(Eq, Show)

pub fn RiFlag::new() -> RiFlag {
  0
}

/// Flags provided to `sock_recv`.
/// 
/// - Recv_peek: Returns the message without removing it from the socket's receive queue.
/// - Recv_waitall: On byte-stream sockets, block until the full amount of data can be returned.
pub enum RiFlags {
  Recv_peek
  Recv_waitall
} derive(Eq, Show)

pub fn value(self : RiFlags) -> UInt {
  match self {
    Recv_peek => 1
    Recv_waitall => 2
  }
}

pub fn set(self : RiFlag, flag : RiFlags) -> RiFlag {
  self._ | flag.value()
}

pub fn unset(self : RiFlag, flag : RiFlags) -> RiFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : RiFlag, flag : RiFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Flags returned by `sock_recv`.
pub type RoFlag UInt derive(Eq, Show)

pub fn RoFlag::new() -> RoFlag {
  0
}

/// Flags returned by `sock_recv`.
/// 
/// - Recv_data_truncated: Returned by `sock_recv`: Message data has been truncated.
pub enum RoFlags {
  Recv_data_truncated
} derive(Eq, Show)

pub fn value(self : RoFlags) -> UInt {
  match self {
    Recv_data_truncated => 1
  }
}

pub fn set(self : RoFlag, flag : RoFlags) -> RoFlag {
  self._ | flag.value()
}

pub fn unset(self : RoFlag, flag : RoFlags) -> RoFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : RoFlag, flag : RoFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Flags provided to `sock_send`. As there are currently no flags defined, it must be set to zero.
pub type SiFlag UInt derive(Eq, Show)

pub fn SiFlag::new() -> SiFlag {
  0
}

/// Flags returned by `sock_send`. As there are currently no flags defined, it must be set to zero.
pub enum SiFlags {} derive(Eq, Show)

pub fn value(self : SiFlags) -> UInt {
  match self {
    _ => panic()
  }
}

pub fn set(self : SiFlag, flag : SiFlags) -> SiFlag {
  self._ | flag.value()
}

pub fn unset(self : SiFlag, flag : SiFlags) -> SiFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : SiFlag, flag : SiFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Which channels on a socket to shut down.
pub type SdFlag UInt derive(Eq, Show)

pub fn SdFlag::new() -> SdFlag {
  0
}

/// Which channels on a socket to shut down.
/// 
/// - Rd: Disables further receive operations.
/// - Wr: Disables further send operations.
pub enum SdFlags {
  Rd
  Wr
} derive(Eq, Show)

pub fn value(self : SdFlags) -> UInt {
  match self {
    Rd => 1
    Wr => 2
  }
}

pub fn set(self : SdFlag, flag : SdFlags) -> SdFlag {
  self._ | flag.value()
}

pub fn unset(self : SdFlag, flag : SdFlags) -> SdFlag {
  self._ & (flag.value() ^ 0)
}

pub fn is_set(self : SdFlag, flag : SdFlags) -> Bool {
  (self._ & flag.value()) != 0
}

/// Identifiers for preopened capabilites.
/// 
/// - Dir: A pre-opened directory.
pub enum PreOpenType {
  Dir
}

pub fn value(self : PreOpenType) -> UInt {
  match self {
    Dir => 0
  }
}

pub fn PreOpenType::from_value(value : UInt) -> PreOpenType? {
  match value {
    0 => Some(Dir)
    _ => None
  }
}

/// The content of a `prestat` when type is `preopentype::dir`.
/// 
/// - `pr_name_len`: The length of the directory name for use with `fd_prestat_dir_name`.
pub struct Prestat_dir {
  pr_name_len : Size
}

/// Information about a pre-opened capability.
pub enum Prestat {
  Dir(Prestat_dir)
}
