module Admin
  class UsersController < BaseController
    def index
      authorize User
      @users = policy_scope(User).all
    end

    def new
      authorize User
      @user = User.new
    end

    def edit

    end

    def create
      authorize User
      @user = User.new(permitted_attributes(User))
      if @user.save
        redirect_to(
          { action: :index },
          notice: t("admin.users.created")
        )
      else
        render :new
      end
    end
  end
end
