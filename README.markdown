James' Facebook Lib
-------------------

Over the last year or so I've done a lot of various Facebook integration work. It's usually quite basic - enable facebook login to an existing system, import friends or something similar. The existing facebook gems are usually a bit OTT. I usually end up writing my own stuff to do what I want. I usually end up copying across what I did last time. It's got quite nifty, and seeing as I end up re-using these few lines of code across so many projects, I might as well publish them.

This is not a gem, as you will probably end up customising it to suit your needs. Also, of course, no guarantees etc. This is under whichever license allows me to simply not care what you do with it. MIT? Probably that one.

It has specs - you will need webmock to get them working.

Facebook api settings are kept separate to this project. You will need facebook_application_id, facebook_application_key and facebook_application_secret set somewhere (I usually use a yml file loaded by an initialiser).

Example controller usage:

def create
  redirect_to FacebookAuthSession.facebook_auth_url(return_for_facebook_session_url, [:email, :offline_access])
end

def return_for
  facebook_auth_session = FacebookAuthSession.new(:code => params[:code], :return_url => return_for_facebook_session_url)
  facebook_auth_session.get_access_token
  user = User.find_or_create_from_facebook_user_details(facebook_auth_session.get_user_details)
end
