class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
  #  puts @webhook
		Messagehuman.sendMessage(@webhook["response_url"][0], "showing posts from #{@webhook["text"][0]}...")
    # getting the product hunt page that day
    @phPage = HTTParty.get("https://www.producthunt.com/topics/#{@webhook["text"][0]}")
    @phPage = @phPage.to_s
		#puts @phPage

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
			#   puts @finalTitles

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
			#   puts @finalLinks

			@phPageTagline = @phPageArray.split('tagline_619b7">')
			@phPageTagline.shift
			@finalTaglines = Array.new
	    @phPageTagline.each do |tagline|
			 	taglineChar = tagline.split("")
				theTagline = String.new
				taglineChar.each do |char|
					if char != '<'
						theTagline = theTagline + char
					else
						break
					end
				end
				break if @finalTaglines.count == 5
				@finalTaglines.push(theTagline)
			end
			#puts @finalTaglines.inspect


			counter = 0
			numCounter = 1
			@finalMessage = String.new
			while numCounter <= 5
				@finalMessage = @finalMessage + "#{numCounter}. " + "#{@finalTitles[counter]} - #{@finalTaglines[counter]} - <#{@finalLinks[counter]}>" + "\n"
				attachment = [
					{
						:fallback => "#{@finalTitles[0]} - #{@finalTaglines[0]} - <#{@finalLinks[0]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[0]}",
						:title_link => "#{@finalLinks[0]}",
						:text => "#{@finalTaglines[0]}"
					},
					{
						:fallback => "#{@finalTitles[1]} - #{@finalTaglines[1]} - <#{@finalLinks[1]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[1]}",
						:title_link => "#{@finalLinks[1]}",
						:text => "#{@finalTaglines[1]}"
					},
					{
						:fallback => "#{@finalTitles[2]} - #{@finalTaglines[2]} - <#{@finalLinks[2]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[2]}",
						:title_link => "#{@finalLinks[2]}",
						:text => "#{@finalTaglines[2]}"
					},
					{
						:fallback => "#{@finalTitles[3]} - #{@finalTaglines[3]} - <#{@finalLinks[3]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[3]}",
						:title_link => "#{@finalLinks[3]}",
						:text => "#{@finalTaglines[3]}"
					},
					{
						:fallback => "#{@finalTitles[4]} - #{@finalTaglines[4]} - <#{@finalLinks[4]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[4]}",
						:title_link => "#{@finalLinks[4]}",
						:text => "#{@finalTaglines[4]}"
					}
				]
				counter += 1
			end
			sendIT = Messagehuman.sendMessageAttach(@webhook["response_url"][0], "hey there", attachment)
			puts sendIT
		end
  end
end
