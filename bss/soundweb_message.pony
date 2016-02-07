primitive SoundwebSpecial
  fun stx(): U8 => 0x02
  fun etx(): U8 => 0x03
  fun ack(): U8 => 0x06
  fun nak(): U8 => 0x15
  fun esc(): U8 => 0x1B

  fun apply(): Array[U8] =>
    [stx(), etx(), ack(), nak(), esc()]

primitive SoundwebCommand
  fun set_sv(): U8 => 0x88
  fun subscribe_sv(): U8 => 0x89
  fun unsubscribe_sv(): U8 => 0x8A
  fun venue_preset_recall(): U8 => 0x8B
  fun param_preset_recall(): U8 => 0x8C
  fun set_sv_percent(): U8 => 0x8D
  fun subscribe_sv_percent(): U8 => 0x8E
  fun unsubscribe_sv_percent(): U8 => 0x8F
  fun bump_sv_percent(): U8 => 0x90

interface SoundwebMessage
  fun encode(command: U8, address: U64, sv: U16, data: U32): Array[U8] val =>
    var bytes = Array[U8]

    bytes.push(command)

    bytes = bytes.concat(_var_to_bytes(address, 6).values())
    bytes = bytes.concat(_var_to_bytes(sv, 2).values())
    bytes = bytes.concat(_var_to_bytes(data, 4).values())

    bytes.push(_checksum(bytes))

    var reserved_bytes: Array[U8] = SoundwebSpecial()
    var escaped_bytes = recover trn Array[U8] end
    var len: USize = bytes.size()
    var i: USize = 0

    escaped_bytes.push(SoundwebSpecial.stx())

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
          escaped_bytes.push(SoundwebSpecial.esc())
          escaped_bytes.push(bytes(i) + 0x80)
        else
          escaped_bytes.push(bytes(i))
        end
      end

      i = i + 1
    end

    escaped_bytes.push(SoundwebSpecial.etx())
    escaped_bytes

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
