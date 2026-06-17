class BulletinPolicy < ApplicationPolicy
  def show?
    record.published? || owner? || user&.admin?
  end

  private

  def owner?
    user.present? && record.user == user
  end
end
