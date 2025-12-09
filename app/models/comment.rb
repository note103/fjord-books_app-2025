# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  alias_attribute :content, :body

  validates :content, presence: true
end
