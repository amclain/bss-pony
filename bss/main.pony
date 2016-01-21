actor Main
  let _sleep_delay: I32 = 2
  let _address: U64 = 0x100103000137

  new create(env: Env) =>
    var soundweb = Soundweb.create(_address, env)
    
    // Gain 100%
    soundweb.setsvpercent(0x00, 100)
    @sleep[I32](_sleep_delay)

    // Gain 50%
    soundweb.setsvpercent(0x00, 50)
    @sleep[I32](_sleep_delay)

    // Gain 0%
    soundweb.setsvpercent(0x00, 0)
    @sleep[I32](_sleep_delay)
