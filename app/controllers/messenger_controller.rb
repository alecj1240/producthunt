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
    @phPageArray = @phPageArray.split('secondaryContent_cdfcd')
    @phPageArray.pop
		@phPageArray = @phPageArray[0]
		#getting the titles
    @phPageTitles = @phPageArray
		@phPageTitles = @phPageTitles.split('title_9ddaf">')
		@phPageTitles.shift
		@finalTitles = Array.new
    @phPageTitles.each do |title|
		 	titleChar = title.split("")
			theTitle = String.new
			titleChar.each do |char|
				if char != "<"
					theTitle = theTitle + char
				else
					break
				end
			end
			break if @finalTitles.count == 5
			@finalTitles.push(theTitle)
		end
		puts @finalTitles

		# getting the ph turbolinks
		@phPageLinks = @phPageArray.split('link_523b9" href="')
		@phPageLinks.shift
		@finalLinks = Array.new
    @phPageLinks.each do |link|
		 	linkChar = link.split("")
			theLink = String.new
			linkChar.each do |char|
				if char != '"'
					theLink = theLink + char
				else
					break
				end
			end
			break if @finalLinks.count == 5
			theLink = "https://www.producthunt.com" + theLink
			@finalLinks.push(theLink)
		end
		puts @finalLinks

		@finalMessage = "#{@finalTitles[0]} - <#{@finalLinks[0]}>" + "\n" + "#{@finalTitles[1]} - <#{@finalLinks[1]}>" + "\n" + "#{@finalTitles[2]} - <#{@finalLinks[2]}>" + "\n" + "#{@finalTitles[3]} - <#{@finalLinks[3]}>" + "\n" + "#{@finalTitles[4]} - <#{@finalLinks[4]}>"

		Messagehuman.sendMessage(@webhook["response_url"][0], @finalMessage)

  end
end
