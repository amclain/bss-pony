actor Main
  let _host: String = "127.0.0.1"
  let _service: String = "1023"
  let _address: U64 = 0x100103000137
  let _sleep_delay: I32 = 2

  new create(env: Env) =>
    var soundweb = Soundweb.create(_host, _service, _address, env)
    
    // Gain 100%
    soundweb.setsvpercent(0x00, 100)
    @sleep[I32](_sleep_delay)

    // Gain 50%
    soundweb.setsvpercent(0x00, 50)
    @sleep[I32](_sleep_delay)

    // Gain 0%
    soundweb.setsvpercent(0x00, 0)
    @sleep[I32](_sleep_delay)

    // Disconnect
    soundweb.dispose()
