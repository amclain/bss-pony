trait SoundwebMessage
  fun encode(command: U8, address: U64, sv: U16, data: U32): Array[U8] =>
    var bytes = Array[U8]
    var buffer = Array[U8]

    bytes.push(command)

    var len: U8 = 6
    var address' = address
    while len > 0 do
      buffer.push((address' and 0xFF).u8())

      address' = address' >> 8
      len = len - 1
    end

    bytes = bytes.concat(buffer.reverse().values())
    buffer.clear()

    len = 2
    var sv' = sv
    while len > 0 do
      buffer.push((sv' and 0xFF).u8())

      sv' = sv' >> 8
      len = len - 1
    end

    bytes = bytes.concat(buffer.reverse().values())
    buffer.clear()

    len = 4
    var data' = data
    while len > 0 do
      buffer.push((data' and 0xFF).u8())

      data' = data' >> 8
      len = len - 1
    end

    bytes = bytes.concat(buffer.reverse().values())
    buffer.clear()

    // var checksum: U8 = 0
    // for byte in bytes.values() do
    //   checksum = checksum xor byte
    // end

    // bytes.push(checksum)

    // var reserved_bytes: Array[U8] = [0x02, 0x03, 0x06, 0x15, 0x1B]
    var escaped_bytes: Array[U8] = [0x02]
    // for byte in bytes.values() do
    //   var is_reserved: Bool = false

    //   for reserved_byte in reserved_bytes.values() do
    //     if byte == reserved_byte then
    //       is_reserved = true
    //       continue
    //     end
    //   end

    //   if is_reserved then
    //     escaped_bytes.push(0x1B)
    //     escaped_bytes.push(byte + 0x80)
    //   else
    //     escaped_bytes.push(byte)
    //   end
    // end

    escaped_bytes.push(0x03) // ETX

  fun decode(): Bool =>
    false
