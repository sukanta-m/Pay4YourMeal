class MembershipsController < ApplicationController
  include Devise::Controllers::Helpers

  def create
    user = User.find_by_email(params[:email])
    if user
      member = user.members.find_by(group_id: current_group.id)
      if member && member.is_accepted
        flash[:warning] = "Already member of this group"
      elsif member
        flash[:warning] = "Request sent again"
        member.token = Member.generate_token
        member.save
        user.send_membership_request member, get_full_path
      else
        member = Member.new(user: user, group: current_group, token: Member.generate_token)
        member.save
        user.send_membership_request member, get_full_path
        flash[:success] = 'Invitation has send'
      end
    else
      user = User.new(email: params[:email])
      user.save(validate: false)
      member = Member.new(user: user, group: current_group, token: Member.generate_token)
      member.save
      user.send_membership_request member, get_full_path
      flash[:success] = 'Invitation has send'
    end
    redirect_to current_group
  end

  def accept
    if params[:token] && member = Member.find_by_token(params[:token])
      if member.user.valid?
        member.update_attributes(is_accepted: true)
        sign_in member.user
        flash[:success] = "Now you have been an active member of #{member.group.name} group"
      else
        redirect_to membership_add_password_path(membership_id: member.id, token: params[:token])
      end
    else
      flash[:danger] = "Invalid token"
      redirect_to root_path
    end
  end

  def add_password
    @member = Member.find_by_id(params[:membership_id])
  end

  def update_member_details
    if params[:membership_id] && member = Member.find_by_id(params[:membership_id])
      if member.user.update_attributes(user_params)
        member.update_attributes(is_accepted: true)
        flash[:success] = "You are now an active member of #{member.group.name} group."
        sign_in member.user
        redirect_to root_path
      else
        @member = member
        render :add_password
      end
    end
  end

  private

  def get_full_path
    memberships_invitation_url :host => request.domain
  end

  def user_params
    params.require(:member).permit(:first_name, :last_name, :password, :password_confirmation)
  end
end
