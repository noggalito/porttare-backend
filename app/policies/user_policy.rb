class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    is_admin?
  end

  private

  def is_admin?
    user.admin?
  end
end
