class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
    puts @webhook
		Messagehuman.sendMessage(@webhook["response_url"][0], "showing posts from #{@webhook["text"][0]}...")
    # getting the product hunt page that day
    @phPage = HTTParty.get("https://www.producthunt.com/topics/#{@webhook["text"][0]}")
    @phPage = @phPage.to_s

		if @phPage.include?("Page not found")
			Messagehuman.sendMessage(@webhook["response_url"][0], "sorry, we couldn't find that topic, try: tech, productivity, developer-tools")
		else
    	#trimming down the excess

	    @phPageArray = @phPage
			if @phPageArray.include?("Today")
				@phPageArray = @phPageArray.split('Today')
			else
				@phPageArray = @phPageArray.split('placeholder="Filter Posts"')
			end
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

			@finalMessage = "1. " + "#{@finalTitles[0]} - <#{@finalLinks[0]}>" + "\n" + "2. " + "#{@finalTitles[1]} - <#{@finalLinks[1]}>" + "\n" + "3. " + "#{@finalTitles[2]} - <#{@finalLinks[2]}>" + "\n" + "4. " + "#{@finalTitles[3]} - <#{@finalLinks[3]}>" + "\n" + "5. " + "#{@finalTitles[4]} - <#{@finalLinks[4]}>"

			Messagehuman.sendMessage(@webhook["response_url"][0], @finalMessage)

		end
  end
end
