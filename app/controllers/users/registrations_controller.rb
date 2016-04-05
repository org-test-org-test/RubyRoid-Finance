class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, only: [:create]

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :birthday, :phone)
  end
end
