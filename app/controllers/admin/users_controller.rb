class Admin::UsersController < Admin::BaseController
  before_action :find_user, only: [:show, :update]

  def index
    @user = User.order_user.page(params[:page])
                .per_page Settings.admin.per_page
  end

  def show; end

  def update
    respond_to do |format|
      case params[:type]
      when "block"
        @user&.block!
        format.js{render "admin/users/unblock"}
      when "unblock"
        @user&.unblock!
        format.js{render "admin/users/block"}
      when "mod"
        @user&.mod!
        format.js{render "admin/users/degrade"}
      when "member"
        @user&.member!
        format.js{render "admin/users/upgrade"}
      else
        format.html
      end
    end
  end
end
