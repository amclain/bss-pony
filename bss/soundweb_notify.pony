use "net"

class SoundwebNotify is TCPConnectionNotify
  fun ref connected(conn: TCPConnection ref) =>
    conn.set_nodelay(true)
