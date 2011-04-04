class FacebookApi < Facebook
  def friends_of(facebook_id)
    response = JSON.parse(http.get("/#{facebook_id}/friends?access_token=#{self.access_token}").body)
    if response["data"]
      response["data"]
    elsif response["error"]
      raise response["error"]["message"]
    end
  end
end