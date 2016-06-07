class PasswordsController < Devise::PasswordsController

  def create
    @user = resource_name.to_s.capitalize.constantize.where(:email => params[resource_name][:email].downcase).first
    if @user
      @user.send_password_reset get_url
      flash[:success] = "Email sent with password reset instructions."
      redirect_to new_session_path(@user)
    else
      @user = User.new(password_params)
      @user.errors.add(:email,"Invalid email")
      render :new
    end
  end

  def update
    @user = resource_name.to_s.capitalize.constantize.where(:reset_password_token => params[:user][:reset_password_token]).first
    if @user.nil? || @user.reset_password_sent_at < 6.hours.ago
      flash[:warning] = "Password reset has expired."
      redirect_to "/#{resource_name.to_s}s/password/new"
    elsif @user && @user.update_attributes(password_params)
      flash[:success] = "Password has been reset!"
      redirect_to new_session_path(@user)
    else
      render :edit
    end
  end

  private
  def get_url
    edit_user_password_url :host => request.domain
  end

  def password_params
    params.require(resource_name).permit(:reset_password_token, :password,:password_confirmation,:email)
  end
end
