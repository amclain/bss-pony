interface SoundwebMessage
  fun encode(command: U8, address: U64, sv: U16, data: U32): Array[U8] =>
    var bytes = Array[U8]
    var buffer = Array[U8]

    bytes.push(command)

    var len: USize = 6
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

    var checksum: U8 = 0
    var i: USize = 0
    len = bytes.size()
    while i < len do
      try
        checksum = checksum xor bytes(i)
      end

      i = i + 1
    end

    bytes.push(checksum)

    var reserved_bytes: Array[U8] = [0x02, 0x03, 0x06, 0x15, 0x1B]
    var escaped_bytes: Array[U8] = [0x02]
    i = 0
    len = bytes.size()
    while i < len do
      var is_reserved: Bool = false
      var len2: USize = reserved_bytes.size()
      var j: USize = 0

      while j < len2 do
        try
          if bytes(i) == reserved_bytes(j) then
            is_reserved = true
            break
          end
        end

        j = j + 1
      end

      try
        if is_reserved then
          escaped_bytes.push(0x1B)
          escaped_bytes.push(bytes(i) + 0x80)
        else
          escaped_bytes.push(bytes(i))
        end
      end

      i = i + 1
    end

    escaped_bytes.push(0x03) // ETX

  fun decode(): Bool =>
    false
