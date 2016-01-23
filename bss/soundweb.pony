use "net"

actor Soundweb
  let _env: Env
  let _host: String
  let _service: String
  let _address: U64

  var _socket: TCPConnection

  new create(host: String, service: String, address: U64, env: Env) =>
    _env = env
    _host = host
    _service = service
    _address = address
    _socket = TCPConnection.create(SoundwebNotify, _host, _service)

  be setsvpercent(sv: U16, value: U32) =>
    _env.out.print(
      "setsvpercent :: " +
      "address: " + _address.string(FormatHex) + " " +
      "sv: " + sv.string(FormatHex) + " " +
      "value: " + value.string()
    )

    _socket.write("test\n")

  be dispose() =>
    _socket.dispose()
