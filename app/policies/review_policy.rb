class ReviewPolicy < ApplicationPolicy
  # Who can see the review? Everyone!

  def index?
    # If viewing a specific user's reviews, only that user or admin can see
    if @record.is_a?(User)
      user.present? && (@record == user || user.admin?)
    else
      # Book reviews or general reviews - public
      true
    end
  end

  def show?
    true
  end

  # Who can create a review? Any logged-in user
  def create?
    user.present?
  end

  # Who can update a review? Only the owner
  def update?
    user.present? && record.user == user
  end

  # Who can delete a review? Only the owner
  def destroy?
    user.present? && (record.user == user || user.admin?)
  end
end
