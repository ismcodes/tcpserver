require 'rspec'
require_relative 'tcp_server'
#require 'httparty'?

RSpec.describe "TCP implementation" do

  before :all do
    # will this just stay running? does it need to be threaded separately?
    @tcp = IsaacTCP.new
    # not server because @tcp has a server instance variable within
    # @tcp.start
  end

  describe "#query_resource" do
    it "should return a 200 OK for existing resource" do
      expect(@tcp.query_resource("/welcome").status).to match(/.*200 OK.*/)
    end

    it "should return a 404 Not Found for resource that does not exist" do
      expect(@tcp.query_resource("/unwelcome").status).to match(/.*404 Not Found.*/)
    end
  end

  describe "#server_response" do
    it "should return the status, body length, and body of the input Struct" do
      status = "HTTP/1.11000 Not OK Not Even Close"
      body = "<html></html>"
      htpr = HttpResponse.new(status, body)
      expect(@tcp.server_response(htpr)).to match(/#{status}.*#{body.length}.*#{body}/)
    end

    it "should include the proper headers" do
      htpr = HttpResponse.new('','')
      expect(@tcp.server_response(htpr)).to match(/.*Content-Length:.*Content-type:.*Connection:/)
    end

  end

end
