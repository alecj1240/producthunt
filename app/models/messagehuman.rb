class Messagehuman
  require 'json'


	def self.sendMessage(url, text)
		HTTParty.post(url.to_s, :body => { :response_type => 'ephemeral', :text => text}.to_json,
    :headers => { 'Content-Type' => 'application/json' })
	end

  def self.sendMessageAttach(url, text, attachment)
    HTTParty.post(url.to_s, :body => { :response_type => 'ephemeral', :attachments => attachment}.to_json,
    :headers => { 'Content-Type' => 'application/json' })
  end
end
