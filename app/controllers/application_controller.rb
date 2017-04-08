class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  rescue_from ActionController::RoutingError, ActionController::UnknownController,
              ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound,
              with: lambda { |exception| render_error 404, exception }

  helper_method :current_group, :current_date

  def current_group
    @current_group ||= current_user.get_current_group(session[:group_id])
  end

  def current_date
    DateTime.parse(session[:current_date] || Date.today.to_s)
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:first_name, :last_name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update, keys: registration_params << :current_password)
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    end
  end

  def render_error status, exception
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
