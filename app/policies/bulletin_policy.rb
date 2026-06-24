class BulletinPolicy < ApplicationPolicy
  def show?
    record.published? || owner? || user&.admin?
  end

  def update?
    owner? && (record.draft? || record.rejected?)
  end

  def edit?
    update?
  end

  private

  def owner?
    user.present? && record.user == user
  end
end
