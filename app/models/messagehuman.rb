class Messagehuman
  require 'json'


	def self.sendMessage(url, text)
		HTTParty.post(url.to_s, :body => { :response_type => 'ephemeral', :text => text}.to_json,
    :headers => { 'Content-Type' => 'application/json' })
	end

  def self.phapi()
    HTTParty.post("/v1/me/feed",
    :headers => { 'Content-Type' => 'application/json', 'Authorization' => "be69146902dfda36771878b6a76300ad539d04947cde370de5999aedaa084656", "Host" => "api.producthunt.com" })
  end
end
