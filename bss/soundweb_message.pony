interface SoundwebMessage
  fun encode(command: U8, address: U64, sv: U16, data: U32): Array[U8] =>
    var bytes = Array[U8]

    bytes.push(command)

    bytes = bytes.concat(_var_to_bytes(address, 6).values())
    bytes = bytes.concat(_var_to_bytes(sv, 2).values())
    bytes = bytes.concat(_var_to_bytes(data, 4).values())

    bytes.push(_checksum(bytes))

    var reserved_bytes: Array[U8] = [0x02, 0x03, 0x06, 0x15, 0x1B]
    var escaped_bytes: Array[U8] = [0x02]
    var len: USize = bytes.size()
    var i: USize = 0

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

  fun _var_to_bytes(variable: Unsigned, num_bytes: USize): Array[U8] =>
    var buffer = Array[U8]

    var len = num_bytes
    var variable' = variable.u128()
    while len > 0 do
      buffer.push((variable' and 0xFF).u8())

      variable' = variable' >> 8
      len = len - 1
    end

    buffer.reverse()

  fun _checksum(bytes: Array[U8]): U8 =>
    var checksum: U8 = 0
    var i: USize = 0
    var len: USize = bytes.size()

    while i < len do
      try
        checksum = checksum xor bytes(i)
      end

      i = i + 1
    end

    checksum
