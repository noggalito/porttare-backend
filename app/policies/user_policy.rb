class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    is_admin?
  end

  def new?
    is_admin?
  end

  def create?
    is_admin?
  end

  def permitted_attributes
    [
      :name,
      :nickname,
      :image,
      :email,
      :admin,
      :password,
      :password_confirmation
    ]
  end

  private

  def is_admin?
    user.admin?
  end
end
