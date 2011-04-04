require'spec_helper'

describe FacebookApi do
  it "should be able to find friends with an access token" do
    stub_request(:get, "https://graph.facebook.com/JAMES/friends?access_token=ACCESS_TOKEN").
             to_return(:status => 200, :body => '
             {"data": [
                {
                   "name": "Kate Riley",
                   "id": "309759"
                },
                {
                   "name": "Jonathan Gray",
                   "id": "36900237"
                }]}')
    facebook_api = FacebookApi.new
    facebook_api.access_token = "ACCESS_TOKEN"
    facebook_api.friends_of("JAMES").should == [
      {
         "name" => "Kate Riley",
         "id" => "309759"
      },
      {
         "name" => "Jonathan Gray",
         "id" => "36900237"
      }
    ]
  end
  
  it "should return an error response if error" do
    stub_request(:get, "https://graph.facebook.com/JAMES/friends?access_token=ACCESS_TOKEN").
             to_return(:status => 200, :body => '{
                "error": {
                   "type": "OAuthException",
                   "message": "Invalid OAuth access token."
                }
             }')
    facebook_api = FacebookApi.new
    facebook_api.access_token = "ACCESS_TOKEN"
    lambda {facebook_api.friends_of("JAMES")}.should raise_error("Invalid OAuth access token.")
  end
end
