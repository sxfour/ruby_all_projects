require 'socket'
require 'ipaddr'


def portScanner(ip_range, port, timeout)
  scan_range = IPAddr.new(ip_range).to_range.to_a

  scan_range.each { |ip|
    socket = Socket.new(:INET, :STREAM)
    remote_address = Socket.sockaddr_in(port, ip.to_s)
    begin
      socket.connect_nonblock(remote_address)
    rescue Errno::EINPROGRESS
      # Ignored
    end
    _, sockets, _ = IO.select(nil, [socket], nil, timeout)
    if sockets
      puts "ip: #{ip}, port: #{port} is open"
      socket.close
    else
      puts "ip: #{ip}, port: #{port} is closed"
    end
  }
end

portScanner('192.168.0.0/24', 445, 5)
