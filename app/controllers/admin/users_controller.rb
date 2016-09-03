module Admin
  class UsersController < BaseController
    before_action :authorize_resource
    before_action :find_user,
                  only: [:edit, :update]

    def index
      @users = policy_scope(User).all
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new(user_attributes)
      if @user.save
        redirect_to(
          { action: :index },
          notice: t("admin.users.created")
        )
      else
        render :new
      end
    end

    def update
      if @user.update_attributes(user_attributes)
        redirect_to(
          { action: :index },
          notice: t("admin.users.updated")
        )
      else
        render :edit
      end
    end

    private

    def user_attributes
      attributes = if params[:user][:password].present?
        policy(User).permitted_attributes_with_password
      else
        policy(User).permitted_attributes
      end
      params.require(:user)
            .permit(attributes)
    end

    def authorize_resource
      authorize User
    end

    def find_user
      @user = User.find params[:id]
    end
  end
end
