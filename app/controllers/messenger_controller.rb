class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
    puts @webhook
    testMessage = Messagehuman.sendMessage(@webhook["response_url"][0], "we are retreiving that info...")

    # getting the product hunt page that day
    @phPage = HTTParty.get("https://www.producthunt.com/topics/tech")
    @phPage = @phPage.to_s
    #trimming down the excess
    @phPageArray = @phPage.split('Today')
    @phPageArray.shift
    @phPageArray = @phPageArray[0]
		#getting the titles
    @phPageTitles = @phPageArray.split('secondaryContent_cdfcd')
    @phPageTitles.pop
    @phPageTitles = @phPageTitles[0]
		@phPageTitles = @phPageTitles.split('title_9ddaf">')
		@phPageTitles.shift
		@finalTitles = Array.new
    @phPageTitles.each do |title|
			puts title.inspect
		end
  end
end
