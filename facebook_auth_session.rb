class FacebookAuthSession < Facebook
  attr_accessor :return_url
  attr_accessor :code

  def self.facebook_auth_url(return_address, permissions=[])
    "https://#{GraphHost}/oauth/authorize?client_id=#{AppConfig['facebook_application_id']}&display=touch&redirect_uri=#{return_address}#{permission_attributes(permissions)}"
  end

  def get_access_token
    @access_token = Rack::Utils.parse_query(request_access_token(code))["access_token"]
  end

  def get_user_details
    response = http.get("/me?access_token=#{access_token}")
    JSON.parse(response.body)
  end

  def remove_user(user_facebook_id)
    response = http(:old_rest).get("/method/auth.revokeAuthorization?uid=#{user_facebook_id}&access_token=#{AppConfig['facebook_application_id']}|#{AppConfig['facebook_application_secret']}")
    response.body
  end

private

  def facebook_old_rest_api_host
    "api.facebook.com"
  end

  def facebook_oauth_path(code)
    "/oauth/access_token?client_id=#{AppConfig['facebook_application_id']}&redirect_uri=#{return_url}&client_secret=#{AppConfig['facebook_application_secret']}&code=#{URI.escape(code)}"
  end

  def request_access_token(code)
    respose = http.get(facebook_oauth_path(code))
    respose.body
  end

  def self.permission_attributes(permissions)
    if permissions.blank?
      ""
    else
      "&scope=" + permissions.join(",")
    end
  end
end