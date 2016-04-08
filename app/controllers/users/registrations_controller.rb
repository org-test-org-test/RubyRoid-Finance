class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, only: [:create, :update]
  skip_before_action :authenticate_scope!, only: [:update], unless: -> { current_user }

  def new
    if params[:invited_code] && (self.resource = User.where(invited_code: params[:invited_code]).first)
      set_minimum_password_length
      yield resource if block_given?
      self.resource.build_image
      respond_with self.resource
    else
      flash[:danger] = 'Access denied'
      redirect_to new_user_session_path
    end
  end

  def update
    self.resource = if current_user 
      resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    else 
      User.where(email: account_update_params[:email]).first
    end
    self.resource.image || self.resource.build_image
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :birthday, :phone, :invited_code, image_attributes: [:photo, :id] )
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :birthday, :phone, :avatar, :invited_code, image_attributes: [:photo, :id])
  end

  protected

  def update_resource(resource, params)
    current_user ? resource.update_with_password(params) : resource.update_without_password(params)
  end

end
