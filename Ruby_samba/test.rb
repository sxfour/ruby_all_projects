require 'bundler/setup'
require 'ruby_smb'

def run_authentication(address, smb1, smb2, smb3, username, password)
  begin
    # Create our socket and add it to the dispatcher
    sock = TCPSocket.new address, 445
    dispatcher = RubySMB::Dispatcher::Socket.new(sock)

    client = RubySMB::Client.new(dispatcher, smb1: smb1, smb2: smb2, smb3: smb3, username: username, password: password)
    protocol = client.negotiate
    status = client.authenticate

    puts "#{protocol} : #{status}"

    if protocol == 'SMB1'
      puts "Native OS: #{client.peer_native_os}"
      puts "Native LAN Manager: #{client.peer_native_lm}"
    end
    puts "Netbios Name: #{client.default_name}"
    puts "Netbios Domain: #{client.default_domain}"
    puts "FQDN of the computer: #{client.dns_host_name}"
    puts "FQDN of the domain: #{client.dns_domain_name}"
    puts "FQDN of the forest: #{client.dns_tree_name}"
    puts "Dialect: #{client.dialect}"
    puts "OS Version: #{client.os_version}"
  rescue StandardError => err
    puts err.backtrace
  end

end

address  = ARGV[0]
username = ARGV[1]
password = ARGV[2]

# Negotiate with SMB1, SMB2 and SMB3 enabled on the client
run_authentication('192.168.0.109', false, true, true, 'kip', 'teplos')
# # Negotiate with both SMB1 and SMB2 enabled on the client
# run_authentication(address, true, true, false, username, password)
# # Negotiate with only SMB1 enabled
# run_authentication(address, true, false, false, username, password)
# # Negotiate with only SMB2 enabled
# run_authentication(address, false, true, false, username, password)
# # Negotiate with only SMB3 enabled
# run_authentication(address, false, false, true, username, password)