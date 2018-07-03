# `require` will read and execute this file:
# /Users/terrell/.rbenv/versions/2.5.1/lib/ruby/2.5.0/socket.rb
require "socket"
require "rubygems"
require "bundler/setup"
require "mysql2"

# Executes report.rb, producing no output,
# after which, report_all func will be defined.
require "/Users/terrell/Code/http_server/lib/report.rb"
client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "inquiry")
results = client.query("SELECT * FROM cars where name='Ford Focus ST'")

def plain_result(results)
  results.to_a.to_s
end


message = <<~MSG
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="css/http_server.css"
</head>
<body>
  <h1>
    #{plain_result(results)}
  </h1>
</body>
<footer>
</footer>
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
