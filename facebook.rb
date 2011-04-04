# TODO: Move this somewhere sensible, and only require as necessary
require 'net/http'
require 'net/https'

class Facebook
  attr_accessor :access_token
  cattr_accessor :application_id, :application_secret
  GraphHost = "graph.facebook.com"
  
  def initialize(values={})
    values.each_pair do |attribute, value|
      instance_variable_set("@#{attribute}", value)
    end
  end
  
  def http(api=:graph)
    if api == :graph
      http = Net::HTTP.new(GraphHost, 443)
    elsif api == :old_rest
      http = Net::HTTP.new(facebook_old_rest_api_host, 443)
    else
      raise "No such supported facebook api host"
    end
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO: Return to check this before we get to production!
    http
  end
  
end