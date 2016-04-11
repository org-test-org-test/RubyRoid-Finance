class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth_log_in(request.env["omniauth.auth"])

    if @user
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      @invitation = Invitation.where(invited_code: session["invited_code"]).first
      if @invitation.present?
        User.from_omniauth_sign_up(request.env["omniauth.auth"])
        redirect_to user_session_path
      else
        flash[:danger] = 'Ask admin'
        redirect_to new_user_session_path
      end
    end
  end

  def failure
    redirect_to root_path
  end
end