class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
    puts @webhook
    testMessage = Messagehuman.sendMessage(@webhook["response_url"][0], "we are retreiving that info...")

    @phPage = HTTParty.get("https://www.producthunt.com/topics/tech")
    @phPage = @phPage.to_s
    @phPageArray = @phPage.split('<body class="env-production">')
    @phPageArray.shift
    puts @phPageArray
    puts @phPageArray.count
    @phPageArray = @phPageArray[0]
    @phPageArray = @phPageArray.split('secondaryContent_cdfcd')
    puts @phPageArray.count
    @phPageArray.pop
    puts @phPageArray.count
  end
end
