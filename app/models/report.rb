# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def owned_by?(user)
    self.user == user
  end
end
