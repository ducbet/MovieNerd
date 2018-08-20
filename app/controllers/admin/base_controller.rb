class Admin::BaseController < ApplicationController
  include UsersHelper
  include SessionsHelper
  before_action :admin_required

  protected

  def admin_required
    return if current_user && (current_user.admin? || current_user.mod?)
    redirect_to root_url
  end
end
