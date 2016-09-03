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

  def edit?
    is_admin?
  end

  def update?
    is_admin?
  end

  def permitted_attributes
    [
      :name,
      :nickname,
      :image,
      :email,
      :admin
    ]
  end

  def permitted_attributes_with_password
    # programatically permit the following so
    # we don't mistakenly override
    permitted_attributes + [
      :password,
      :password_confirmation
    ]
  end

  private

  def is_admin?
    user.admin?
  end
end
