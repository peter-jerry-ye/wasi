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
    Append => FDFlag(self.0.lor((1).lsl(0)))
    DSync => FDFlag(self.0.lor((1).lsl(1)))
    Non_block => FDFlag(self.0.lor((1).lsl(2)))
    RSync => FDFlag(self.0.lor((1).lsl(3)))
    Sync => FDFlag(self.0.lor((1).lsl(4)))
  }
}

pub fn unset(self : FDFlag, flag : FDFlags) -> FDFlag {
  match flag {
    Append => FDFlag(self.0.land((1).lsl(0).lxor(0)))
    DSync => FDFlag(self.0.land((1).lsl(1).lxor(0)))
    Non_block => FDFlag(self.0.land((1).lsl(2).lxor(0)))
    RSync => FDFlag(self.0.land((1).lsl(3).lxor(0)))
    Sync => FDFlag(self.0.land((1).lsl(4).lxor(0)))
  }
}

pub enum FDRights {
  Datasync
  Read
  Write
  Allocate
  Read_dir
}

pub(readonly) type FDRight Int64

pub fn FDRight::make() -> FDRight {
  FDRight(0L)
}

pub fn set(self : FDRight, flag : FDRights) -> FDRight {
  match flag {
    Datasync => FDRight(self.0.lor((1L).lsl(0L)))
    Read => FDRight(self.0.lor((1L).lsl(1L)))
    Write => FDRight(self.0.lor((1L).lsl(6L)))
    Allocate => FDRight(self.0.lor((1L).lsl(8L)))
    Read_dir => FDRight(self.0.lor((1L).lsl(14L)))
  }
}

pub fn unset(self : FDRight, flag : FDRights) -> FDRight {
  match flag {
    Datasync => FDRight(self.0.land((1L).lsl(0L).lxor(0L)))
    Read => FDRight(self.0.land((1L).lsl(1L).lxor(0L)))
    Write => FDRight(self.0.land((1L).lsl(6L).lxor(0L)))
    Allocate => FDRight(self.0.land((1L).lsl(8L).lxor(0L)))
    Read_dir => FDRight(self.0.land((1L).lsl(14L).lxor(0L)))
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
    Symlink_follow => LookupFlag(self.0.lor((1).lsl(0)))
  }
}

pub fn unset(self : LookupFlag, flag : LookupFlags) -> LookupFlag {
  match flag {
    Symlink_follow => LookupFlag(self.0.land((1).lsl(0).lxor(0)))
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
    Create => OpenFlag(self.0.lor((1).lsl(0)))
    Directory => OpenFlag(self.0.lor((1).lsl(1)))
    Excl => OpenFlag(self.0.lor((1).lsl(2)))
    Trunc => OpenFlag(self.0.lor((1).lsl(3)))
  }
}

pub fn unset(self : OpenFlag, flag : OpenFlags) -> OpenFlag {
  match flag {
    Create => OpenFlag(self.0.land((1).lsl(0).lxor(0)))
    Directory => OpenFlag(self.0.land((1).lsl(1).lxor(0)))
    Excl => OpenFlag(self.0.land((1).lsl(2).lxor(0)))
    Trunc => OpenFlag(self.0.land((1).lsl(3).lxor(0)))
  }
}