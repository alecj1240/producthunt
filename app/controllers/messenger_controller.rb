class MessengerController < ApplicationController
	protect_from_forgery with: :null_session
	require 'httparty'
	require 'json'
	require 'cgi'

  def receive_message
    @webhook = CGI::parse(request.raw_post)
  #  puts @webhook
		if @webhook["text"][0] == "" || @webhook["text"][0] == " "
			@webhook["text"][0] = "tech"
		end
		Messagehuman.sendMessage(@webhook["response_url"][0], "showing posts from #{@webhook["text"][0]}...")
    # getting the product hunt page that day
    @phPage = HTTParty.get("https://www.producthunt.com/topics/#{@webhook["text"][0]}")
    @phPage = @phPage.to_s
		puts @phPage

		if @webhook["text"][0] == "help"
			Messagehuman.sendMessage(@webhook["response_url"][0], "to use me: '/ph tech', or you can replace tech with: producitivy, developer-tools, games, books, bots, and many more!")
		elsif @phPage.include?("Page not found")
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
				theLink = theLink.gsub!(" ", "-")
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

			@phPageVote = @phPageArray.split('<div class="icon_f5f81"></div> <!-- -->')
			@phPageVote.shift
			@finalVotes = Array.new
	    @phPageVote.each do |vote|
			 	voteChar = vote.split("")
				theVote = String.new
				voteChar.each do |char|
					if char != '<'
						theVote = theVote + char
					else
						break
					end
				end
				break if @finalVotes.count == 5
				@finalVotes.push(theVote)
			end

			#
			@phPageImg = @phPageArray.split('img src="')
			@phPageImg.shift
			@finalImgs = Array.new
	    @phPageImg.each do |img|
			 	imgChar = img.split("")
				theImg = String.new
				imgChar.each do |char|
					if char != '"'
						theImg = theImg + char
					else
						break
					end
				end
				break if @finalImgs.count == 5
				@finalImgs.push(theImg)
			end



			#puts @finalTaglines.inspect
				attachment = [
					{
						:thumb_url => "#{@finalImgs[0]}",
						:fallback => "#{@finalTitles[0]} - #{@finalTaglines[0]} - <#{@finalLinks[0]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[0]}",
						:title_link => "#{@finalLinks[0]}",
						:text => "#{@finalTaglines[0]}",
						fields: [
                {
                    title: "Vote Count: #{@finalVotes[0]}"
                }
            ]
					},
					{
						:thumb_url => "#{@finalImgs[1]}",
						:fallback => "#{@finalTitles[1]} - #{@finalTaglines[1]} - <#{@finalLinks[1]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[1]}",
						:title_link => "#{@finalLinks[1]}",
						:text => "#{@finalTaglines[1]}",
						fields: [
                {
                    title: "Vote Count: #{@finalVotes[1]}"
                }
            ]
					},
					{
						:thumb_url => "#{@finalImgs[2]}",
						:fallback => "#{@finalTitles[2]} - #{@finalTaglines[2]} - <#{@finalLinks[2]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[2]}",
						:title_link => "#{@finalLinks[2]}",
						:text => "#{@finalTaglines[2]}",
						fields: [
                {
                    title: "Vote Count: #{@finalVotes[2]}"
                }
            ]
					},
					{
						:thumb_url => "#{@finalImgs[3]}",
						:fallback => "#{@finalTitles[3]} - #{@finalTaglines[3]} - <#{@finalLinks[3]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[3]}",
						:title_link => "#{@finalLinks[3]}",
						:text => "#{@finalTaglines[3]}",
						fields: [
                {
                    title: "Vote Count: #{@finalVotes[3]}"
                }
            ]
					},
					{
						:thumb_url => "#{@finalImgs[4]}",
						:fallback => "#{@finalTitles[4]} - #{@finalTaglines[4]} - <#{@finalLinks[4]}>",
						:color => "#36a64f",
						:title => "#{@finalTitles[4]}",
						:title_link => "#{@finalLinks[4]}",
						:text => "#{@finalTaglines[4]}",
						fields: [
                {
                    title: "Vote Count: #{@finalVotes[4]}"
                }
            ]
					}
				]
			Messagehuman.sendMessageAttach(@webhook["response_url"][0], "", attachment)
		end
  end

end
