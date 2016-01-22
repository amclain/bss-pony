use "ponytest"
use ".."

class TestSoundwebMessage is UnitTest
  fun name(): String => "Soundweb Message"

  fun ref apply(h: TestHelper): TestResult =>
    true
