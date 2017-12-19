class PagesController < ApplicationController
  def index
  end

  def contact
  end

  def privacy
  end

  def done
		thecode = params["code"]
    puts thecode
		if !thecode.nil?
			puts "THE TOKEN!"
			@theToken = HTTParty.get("https://slack.com/api/oauth.access?client_id=219592720864.285551398295&client_secret=6546a0cc240d1946aa66f60f6bbcacd3&code=#{thecode}")
			puts @theToken
		end
	end

end
