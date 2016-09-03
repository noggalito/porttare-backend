module Admin
  class BaseController < ::ApplicationController
    before_action :authenticate_admin!
    before_action :ensure_is_admin!

    layout "admin"

    alias_method :pundit_user, :current_admin

    # help airbrake identify current user
    alias_method :current_member, :current_admin
    # and expose it to views so it's accessible
    helper_method :current_member

    protected

    def t(key)
      I18n.t(key)
    end

    def ensure_is_admin!
      redirect_to(
        root_path,
        error: I18n.t("pundit.not_authorized")
      ) unless current_admin.admin?
    end
  end
end
