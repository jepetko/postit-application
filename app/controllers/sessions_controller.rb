class SessionsController < ApplicationController

  def new
  end

  def create
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      # to grant or deny the access to /pin later
      session[:two_factor] = true
      if user.two_factor_auth?
        user.generate_pin!
        #send the pin to twilio
        send_pin_to(user)
        redirect_to pin_path
      else
        login_user!(user)
      end

    else
      flash[:error] = 'User credentials invalid.'
      # why not render :new
      redirect_to register_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out!"
    redirect_to root_path
  end

  def pin
    access_denied if session[:two_factor].nil?
    if request.post?
      user = User.find_by pin: params[:pin]
      if user
        session[:two_factor] = nil
        user.remove_pin!
        login_user!(user)
      else
        flash[:error] = 'Something is wrong with your pin number.'
        redirect_to pin_path
      end
    end
  end

  private

  def login_user!(user)
    session[:user_id] = user.id
    flash[:notice] = 'You are logged in!'
    redirect_to root_path
  end

  def send_pin_to(user)
    twilio_api_hash = PostitTemplate::Application.config.twilio_credentials
    @twilio_client ||= Twilio::REST::Client.new twilio_api_hash['key'], twilio_api_hash['token']
    begin
      @twilio_client.account.messages.create(:body => user.pin, :to => user.phone, :from => twilio_api_hash['from'])
    rescue Exception => e
      flash[:error] = "Unfortunately, the two-way authentication raised an error: #{e.message}"
    end
  end

end