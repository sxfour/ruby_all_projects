require 'socket'
require 'ipaddr'

def portScanner(ip, port, timeout)
  socket = Socket.new(:INET, :STREAM)
  remote_address = Socket.sockaddr_in(port, ip.to_s)
  begin
    socket.connect_nonblock(remote_address)
  rescue Errno::EINPROGRESS
    # Ignored
  end
  _, sockets, = IO.select(nil, [socket], nil, timeout)
  if sockets
    puts "ip: #{ip}, port: #{port} is open"
    socket.close
  else
    puts "ip: #{ip}, port: #{port} is closed"
  end
end

def threadsPool(ip_range, port, timeout)
  scan_range = IPAddr.new(ip_range).to_range.to_a
  threads = []

  scan_range.each { |ip| threads << Thread.new { portScanner(ip, port, timeout) } }

  threads.each(&:join)
end

threadsPool('192.168.0.0/24', 445, 2)
