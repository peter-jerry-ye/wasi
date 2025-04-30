///|
pub fn start() -> Unit {
  let subscriptions = [
    @wasi.Subscription::{
      u: @wasi.Subscription_u::Clock(@wasi.Subscription_clock::{
        id: @wasi.ClockId::Monotonic,
        timeout: @wasi.TimeStamp(1000000000),
        precision: @wasi.TimeStamp(1),
        flags: @wasi.SubclockFlags::new(),
      }),
      userdata: 0,
    },
    @wasi.Subscription::{
      u: @wasi.Subscription_u::Clock(@wasi.Subscription_clock::{
        id: @wasi.ClockId::Monotonic,
        timeout: @wasi.TimeStamp(1000000000000),
        precision: @wasi.TimeStamp(1),
        flags: @wasi.SubclockFlags::new(),
      }),
      userdata: 1,
    },
  ]
  let result = @wasi.poll_oneoff?(subscriptions)
  guard result is Ok([event])
  guard event.type_ is Clock && event.userdata == 0

}
