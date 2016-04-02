class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  helper_method :currentUser

  after_filter do
    data = {"Request" => {"URL" => request.url, "method" => request.method, "body" => request.body.read}, "Response status code" => response.status, "API client" =>  @app.try(:client_name), "User ID" => @user.try(:id)}
    Rails.logger.info data.as_json
  end

  def currentUser
    if current_user
      @current_user_profile || @current_user_profile = current_user
    else
      nil
    end
  end


  # # include Pundit

  # # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # def after_sign_in_path_for(resource)
  #   AGENTS_CONFIG["homepage"][current_user.user_profile.team] or admin_root_path
  # end

  def after_update_path_for(resource)
    '/'
  end

  def after_sign_out_path_for(resource)
    '/'
  end
  
end
