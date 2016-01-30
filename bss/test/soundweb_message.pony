use "ponytest"
use ".."

class TestSoundwebMessage is UnitTest
  fun name(): String => "Soundweb Message"

  fun ref apply(h: TestHelper): TestResult =>
    let command: U8 = 0x8D
    let address: U64 = 0x100103000137
    let sv: U16 = 0x0000
    let data: U32 = 0x00640000

    let encoded: Array[U8] = [
      0x02, // STX
      0x8D, // Command
      0x10,0x01,0x1B,0x83,0x00,0x01,0x37, // Address
      0x00,0x00, // SV
      0x00,0x64,0x00,0x00, // Data
      0xCD, // Checksum
      0x03 // ETX
    ]

    var subject = SoundwebMessageHost.create()

    for pair in subject.encode(command, address, sv, data).pairs() do
      try
        (var i, var value) = pair
        h.expect_eq[U8](value, encoded(i), "Index: " + i.string())
      end
    end

    true

class SoundwebMessageHost is SoundwebMessage
  new create() =>
    None
