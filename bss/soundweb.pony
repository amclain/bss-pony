actor Soundweb
  let _env: Env
  let _address: U64

  new create(address: U64, env: Env) =>
    _env = env
    _address = address

  be setsvpercent(sv: U16, value: U32) =>
    _env.out.print(
      "setsvpercent :: " +
      "address: " + _address.string() + " " +
      "sv: " + sv.string() + " " +
      "value: " + value.string()
    )
