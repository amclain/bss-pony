use "net"

actor Soundweb is SoundwebMessage
  let _env: Env
  let _host: String
  let _service: String
  let _address: U64
  let _format_hex: FormatSettingsInt

  var _socket: TCPConnection

  new create(host: String, service: String, address: U64, env: Env) =>
    _env = env
    _host = host
    _service = service
    _address = address
    _socket = TCPConnection.create(SoundwebNotify, _host, _service)

    _format_hex = FormatSettingsInt.create()
    _format_hex.set_format(FormatHex)

  be setsvpercent(sv: U16, value: U32) =>
    _env.out.print(
      "setsvpercent :: " +
      "address: " + _address.string(_format_hex) + " " +
      "sv: " + sv.string(_format_hex) + " " +
      "value: " + value.string()
    )

    _socket.write(
      encode(SoundwebCommand.set_sv_percent(),_address, sv, value * 65536)
    )

  be dispose() =>
    _socket.dispose()
