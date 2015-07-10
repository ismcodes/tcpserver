require 'socket'

HttpResponse = Struct.new(:status, :body)

class IsaacTCP

  RESPONSES = {
    "/welcome" =>
      HttpResponse.new(
        "HTTP/1.1 200 OK",
        "<html>
        <head><head>
        <body>
        <p>Hello world!</p>
        </body>
        </html>"
      )
  }
  RESOURCE_NOT_FOUND = HttpResponse.new(
    "HTTP/1.1 404 Not Found",
    "<p>Not found, sorry.</p>"
  )
  # 404 has own variable because that's the only error code ATM
  def client_input(client)
    client.gets.chomp
  end

  def start
    @server = TCPServer.new(2000)
    listen_for_requests
  end

  def listen_for_requests
    loop do
      accept_and_handle_client
    end
  end

  def accept_and_handle_client
    client = server.accept
    client_choice = client_input(client)
    resource_choice = query_resource(client_choice)
    client.puts(server_response(resource_choice))
    client.close
  end

  def query_resource(client_choice)
    RESPONSES[client_choice] || RESOURCE_NOT_FOUND
  end

  def server_response(resource)
      "#{resource.status}
      Content-Length: #{resource.body.length}
      Content-Type: text/html; charset=UTF-8
      Connection: close

      #{resource.body}"

  end

  private
  attr_reader :server

end
