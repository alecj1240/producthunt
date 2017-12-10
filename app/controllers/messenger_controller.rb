class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
    puts @webhook
    testMessage = Messagehuman.sendMessage(@webhook["response_url"][0], "this is a message")
    puts testMessage
  end
end
