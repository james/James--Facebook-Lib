require'spec_helper'

describe FacebookAuthSession do
  before :each do
    @return_url = "http://here.com/there"
    @facebook_auth_session = FacebookAuthSession.new(:return_url => @return_url)
    AppConfig.stub!(:[]).with("facebook_application_id").and_return "FACEBOOK_ID"
    AppConfig.stub!(:[]).with("facebook_application_key").and_return "FACEBOOK_KEY"
    AppConfig.stub!(:[]).with("facebook_application_secret").and_return "FACEBOOK_SECRET"
  end

  describe "facebook_auth_url" do
    it "should generate a correct facebook auth url" do
      FacebookAuthSession.facebook_auth_url(@return_url).should == "https://graph.facebook.com/oauth/authorize?client_id=FACEBOOK_ID&display=touch&redirect_uri=#{@return_url}"
    end

    it "should generate a correct facebook auth url with email permissions" do
      FacebookAuthSession.facebook_auth_url(@return_url, ["email"]).should == "https://graph.facebook.com/oauth/authorize?client_id=FACEBOOK_ID&display=touch&redirect_uri=#{@return_url}&scope=email"
    end
  end

  describe "request_access_token" do
    it "should return the access_token" do
      stubbed_url = "https://graph.facebook.com/oauth/access_token?client_id=FACEBOOK_ID&client_secret=FACEBOOK_SECRET&code=TOKEN&redirect_uri=http://here.com/there"
      stub_request(:get, stubbed_url).to_return(:status => 200, :body => "", :headers => {})
      @facebook_auth_session.send(:request_access_token, "TOKEN")
      WebMock.should have_requested(:get, stubbed_url)
    end
  end

  describe "get_access_token" do
    it "should extract the acess token correctly" do
      @facebook_auth_session.stub!(:request_access_token).and_return("access_token=169089189780199|2.OyY9eiObJU__Lz9gRMwH3w__.3600.1290614400-505538500|K4nDOkvhlNCVgAnoF7vXCopak64&expires=2236")
      @facebook_auth_session.code = "TOKEN"
      @facebook_auth_session.get_access_token.should == "169089189780199|2.OyY9eiObJU__Lz9gRMwH3w__.3600.1290614400-505538500|K4nDOkvhlNCVgAnoF7vXCopak64"
    end
  end

  describe "get_user_details" do
    before :each do
      @facebook_auth_session = FacebookAuthSession.new(:access_token => "ACCESS_TOKEN_STRING")
      @stubbed_url = "https://graph.facebook.com/me?access_token=ACCESS_TOKEN_STRING"
      stub_request(:get, @stubbed_url).to_return(:status => 200, :body => "{}")
    end

    it "should correctly get the JSON of user details from access token" do
      @facebook_auth_session.get_user_details
      WebMock.should have_requested(:get, @stubbed_url)
    end

    it "should parse the response into JSON" do
      JSON.should_receive(:parse).with("{}")
      @facebook_auth_session.get_user_details
    end
  end

  describe "removing a user" do
    before :each do
      @facebook_auth_session = FacebookAuthSession.new
      @stubbed_url = "https://api.facebook.com/method/auth.revokeAuthorization?access_token=FACEBOOK_ID%7CFACEBOOK_SECRET&uid=123456"
      stub_request(:get, @stubbed_url).to_return(:status => 200, :body => "{}")
    end

    it "should send a request to facebook with correct access key and user id to revoke authorization" do
      @facebook_auth_session.remove_user(123456)
      WebMock.should have_requested(:get, @stubbed_url)
    end
  end
end
