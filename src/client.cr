require "json"
require "http/client"

module Crudris
  EFFIS_URL       = "https://cdn.eludris.gay"
  OPRISH_URL      = "https://api.eludris.gay"
  PANDEMONIUM_URL = "wss://ws.eludris.gay/"

  # The base class for initialising a client.
  class Client
    def initialize(
      author_name : String,
      effis_url : String = EFFIS_URL,
      oprish_url : String = OPRISH_URL,
      pandemonium_url : String = PANDEMONIUM_URL
    )
      @author_name = author_name
      @effis_url = effis_url
      @oprish_url = oprish_url
      @pandemonium_url = pandemonium_url
      @ws = nil
    end

    # Connects to the Eludris gateway.
    def connect
      if @author_name.nil?
        raise "Author name cannot be nil."
      elsif @author_name.empty?
        raise "Author name cannot be empty."
      elsif @author_name.size > 32 || @author_name.size < 2
        raise "Author name must be between 2 and 32 characters."
      end

      @ws = HTTP::WebSocket.new @pandemonium_url

      @ws.not_nil!.send(
        {
          "op" => "PING",
        }.to_json
      )

      spawn do
        loop do
          sleep 45
          @ws.not_nil!.send(
            {
              "op" => "PING",
            }.to_json)
        end
      end

      @ws.not_nil!.run
    end

    def close
      @ws.not_nil!.close
      exit(0)
    end

    def create_message(content : String)
      headers = HTTP::Headers{
        "Content-Type" => "application/json",
      }
      resp = HTTP::Client.exec "POST", "#{@oprish_url}/messages", headers, {
        "author"  => @author_name,
        "content" => content,
      }.to_json

	  if resp.status_code == 200
		return JSON.parse resp.body
	  else
		return # TODO: Use Log.exception and implement this better when #1 gets merged
	  end
    end
  end
end
