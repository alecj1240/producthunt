class Messagehuman
  require 'json'


	def self.sendMessage(url, text)
		HTTParty.post(url.to_s, :body => { :response_type => 'ephemeral', :text => text}.to_json,
    :headers => { 'Content-Type' => 'application/json' })
	end

  def self.phapi()
    HTTParty.get("https://api.producthunt.com/v1/me/feed",
    :headers => { 'Content-Type' => 'application/json', 'Authorization' => "c50ca535778cd0210e847818307b36b84dd1503a49c40dc80dacfe76fe1ff4cf"})
  end
end
