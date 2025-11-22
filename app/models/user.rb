# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :avatar,
            content_type: { in: %w[image/jpeg image/png image/gif] },
            size: { less_than: 5.megabytes }
  # エラーメッセージは内容の精度とメンテナンス性を考慮してgemの翻訳を使用
  # https://github.com/igorkasyanchuk/active_storage_validations/blob/master/config/locales/ja.yml
end
