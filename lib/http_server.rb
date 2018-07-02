# `require` will read and execute this file:
# /Users/terrell/.rbenv/versions/2.5.1/lib/ruby/2.5.0/socket.rb
require "socket"

# Executes report.rb, producing no output,
# after which, report_all func will be defined.
require "/Users/terrell/Code/http_server/lib/report.rb"

message = <<~MSG
<html>
<body>
<script>
 document.write ("Goodbye");
</script>
  <h1 style="">Hello World</h1>
</body>
</html>
MSG

server = TCPServer.new 1034 # Server bind to port 1034
loop do
  client = server.accept    # Wait for a client to connect
  client.puts <<~HTTP
    HTTP/1.1 200
    Date: #{Time.now}
    Content-Type: text/html
    Server: Terrell's Awesome Server
    Connection: close
    Content-Length: #{message.length}

    #{message}
  HTTP
  sleep(5)
  client.close
end
