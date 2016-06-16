require 'json'

module OAuthHelper

  def page
    Capybara.current_session
  end

  def prepare_user_oauth(user=nil)
    user ||= @user = create(:user)

    # create client application
    @doorkeeper_app ||= create(:oauth_application)
    client_id = @doorkeeper_app.uid
    client_secret = @doorkeeper_app.secret

    response = page.driver.post '/oauth/token', {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'password',
      username: user.email,
      password: user.password
    }

    # fetch access token
    @token = JSON.parse(response.body)['access_token']
  end


  # make an API GET call, automatically appending current oauth token
  # returns parsed JSON data
  def oauth_get(uri, args={})
    if @token
      response = page.driver.get(uri, { access_token: @token }.merge(args))
    else
      response = page.driver.get(uri, args)
    end
    Rails.logger.debug response.body

    response
  end

  # make an API POST call, automatically appending current oauth token
  # returns parsed JSON data
  def oauth_post(uri, args={})
    if @token
      response = page.driver.post(uri, { access_token: @token }.merge(args))
    else
      response = page.driver.post(uri, args)
    end
    Rails.logger.debug response.body

    response
  end

  # make an API PUT call, automatically appending current oauth token
  # returns parsed JSON data
  def oauth_put(uri, args={})

    if @token
      response = page.driver.put(uri, { access_token: @token }.merge(args))
    else
      response = page.driver.put(uri, args)
    end
    Rails.logger.debug response.body

    response
  end

  # make an API DELETE call, automatically appending current oauth token
  # returns parsed JSON data
  def oauth_del(uri, args={})

    if @token
      response = page.driver.delete(uri, { access_token: @token }.merge(args))
    else
      response = page.driver.delete(uri, args)
    end
    Rails.logger.debug response.body

    response
  end

end
