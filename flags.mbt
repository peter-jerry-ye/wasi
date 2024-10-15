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

pub enum FDFlags {
  Append
  DSync
  Non_block
  RSync
  Sync
}

pub(readonly) type FDFlag Int

pub fn FDFlag::make() -> FDFlag {
  FDFlag(0)
}

pub fn set(self : FDFlag, flag : FDFlags) -> FDFlag {
  match flag {
    Append => FDFlag(self._ | (1 << 0))
    DSync => FDFlag(self._ | (1 << 1))
    Non_block => FDFlag(self._ | (1 << 2))
    RSync => FDFlag(self._ | (1 << 3))
    Sync => FDFlag(self._ | (1 << 4))
  }
}

pub fn unset(self : FDFlag, flag : FDFlags) -> FDFlag {
  match flag {
    Append => FDFlag(self._ & ((1 << 0) ^ 0))
    DSync => FDFlag(self._ & ((1 << 1) ^ 0))
    Non_block => FDFlag(self._ & ((1 << 2) ^ 0))
    RSync => FDFlag(self._ & ((1 << 3) ^ 0))
    Sync => FDFlag(self._ & ((1 << 4) ^ 0))
  }
}

pub enum FDRights {
  Datasync
  Read
  Write
  Allocate
  Read_dir
  Sock_shutdown
  Sock_accept
}

pub(readonly) type FDRight Int64

pub fn FDRight::make() -> FDRight {
  FDRight(0L)
}

pub fn set(self : FDRight, flag : FDRights) -> FDRight {
  match flag {
    Datasync => FDRight(self._ | (1L << 0))
    Read => FDRight(self._ | (1L << 1))
    Write => FDRight(self._ | (1L << 6))
    Allocate => FDRight(self._ | (1L << 8))
    Read_dir => FDRight(self._ | (1L << 14))
    Sock_shutdown => FDRight(self._ | (1L << 28))
    Sock_accept => FDRight(self._ | (1L << 29))
  }
}

pub fn unset(self : FDRight, flag : FDRights) -> FDRight {
  match flag {
    Datasync => FDRight(self._ & ((1L << 0) ^ 0L))
    Read => FDRight(self._ & ((1L << 1) ^ 0L))
    Write => FDRight(self._ & ((1L << 6) ^ 0L))
    Allocate => FDRight(self._ & ((1L << 8) ^ 0L))
    Read_dir => FDRight(self._ & ((1L << 14) ^ 0L))
    Sock_shutdown => FDRight(self._ & ((1L << 28) ^ 0L))
    Sock_accept => FDRight(self._ & ((1L << 29) ^ 0L))
  }
}

pub enum LookupFlags {
  Symlink_follow
}

pub(readonly) type LookupFlag Int

pub fn LookupFlag::make() -> LookupFlag {
  LookupFlag(0)
}

pub fn set(self : LookupFlag, flag : LookupFlags) -> LookupFlag {
  match flag {
    Symlink_follow => LookupFlag(self._ | (1 << 0))
  }
}

pub fn unset(self : LookupFlag, flag : LookupFlags) -> LookupFlag {
  match flag {
    Symlink_follow => LookupFlag(self._ & ((1 << 0) ^ 0))
  }
}

pub enum OpenFlags {
  Create
  Directory
  Excl
  Trunc
}

pub(readonly) type OpenFlag Int

pub fn OpenFlag::make() -> OpenFlag {
  OpenFlag(0)
}

pub fn set(self : OpenFlag, flag : OpenFlags) -> OpenFlag {
  match flag {
    Create => OpenFlag(self._ | (1 << 0))
    Directory => OpenFlag(self._ | (1 << 1))
    Excl => OpenFlag(self._ | (1 << 2))
    Trunc => OpenFlag(self._ | (1 << 3))
  }
}

pub fn unset(self : OpenFlag, flag : OpenFlags) -> OpenFlag {
  match flag {
    Create => OpenFlag(self._ & ((1 << 0) ^ 0))
    Directory => OpenFlag(self._ & ((1 << 1) ^ 0))
    Excl => OpenFlag(self._ & ((1 << 2) ^ 0))
    Trunc => OpenFlag(self._ & ((1 << 3) ^ 0))
  }
}

pub enum RIFlags {
  Recv_Peek
  Recv_Wait_all
}

pub(readonly) type RIFlag Int

pub fn RIFlag::make() -> RIFlag {
  RIFlag(0)
}

pub fn set(self : RIFlag, flag : RIFlags) -> RIFlag {
  match flag {
    Recv_Peek => RIFlag(self._ | (1 << 0))
    Recv_Wait_all => RIFlag(self._ | (1 << 1))
  }
}

pub fn unset(self : RIFlag, flag : RIFlags) -> RIFlag {
  match flag {
    Recv_Peek => RIFlag(self._ & ((1 << 0) ^ 0))
    Recv_Wait_all => RIFlag(self._ & ((1 << 1) ^ 0))
  }
}

pub enum ROFlags {
  Recv_data_truncated
}

pub(readonly) type ROFlag Int

pub fn ROFlag::make() -> ROFlag {
  ROFlag(0)
}

pub fn set(self : ROFlag, flag : ROFlags) -> ROFlag {
  match flag {
    Recv_data_truncated => ROFlag(self._ | (1 << 0))
  }
}

pub fn unset(self : ROFlag, flag : ROFlags) -> ROFlag {
  match flag {
    Recv_data_truncated => ROFlag(self._ & ((1 << 0) ^ 0))
  }
}

pub(readonly) type SIFlag Int

pub fn SIFlag::make() -> SIFlag {
  SIFlag(0)
}

pub enum SDFlags {
  Disable_furthur_receive
  Disable_furthur_send
}

pub(readonly) type SDFlag Int

pub fn SDFlag::make() -> SDFlag {
  SDFlag(0)
}

pub fn set(self : SDFlag, flag : SDFlags) -> SDFlag {
  match flag {
    Disable_furthur_receive => SDFlag(self._ | (1 << 0))
    Disable_furthur_send => SDFlag(self._ | (1 << 1))
  }
}

pub fn unset(self : SDFlag, flag : SDFlags) -> SDFlag {
  match flag {
    Disable_furthur_receive => SDFlag(self._ & ((1 << 0) ^ 0))
    Disable_furthur_send => SDFlag(self._ & ((1 << 1) ^ 0))
  }
}
