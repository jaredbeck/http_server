# `require` will read and execute this file:
# /Users/terrell/.rbenv/versions/2.5.1/lib/ruby/2.5.0/socket.rb
require "socket"
require "rubygems"
require "bundler/setup"
require "mysql2"

db = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "inquiry")

def plain_result(results)
  results.to_a.reduce('') do |a, record|
    a << "<tr><td>#{record['name']}</td></tr>"
  end
end

def query(client)
  results = client.query("SELECT * FROM cars;")
  plain_result(results)
end

def message(client)
  <<~MSG
    <!DOCTYPE html>
    <html>
    <head>
      <link rel="stylesheet" type="text/css" href="css/http_server.css"
    </head>
    <body>
      <table>
        <thead>
          <tr>
            <th>Name</th>
          </tr>
        </thead>
        <tbody>
          #{query(client)}
        </tbody>
      </table>
    </body>
    <footer>
    </footer>
    </html>
  MSG
end

server = TCPServer.new 1034 # Server bind to port 1034
loop do
  client = server.accept    # Wait for a client to connect
  msg = message(db)
  client.puts <<~HTTP
    HTTP/1.1 200
    Date: #{Time.now}
    Content-Type: text/html
    Server: Terrell's Awesome Server
    Connection: close
    Content-Length: #{msg.length}

    #{msg}
  HTTP
  client.close
end
