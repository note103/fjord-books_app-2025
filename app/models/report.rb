# frozen_string_literal: true

class Report < ApplicationRecord
  MENTION_TARGET_DOMAIN = 'http://localhost:3000'

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :sending_mentions,
           class_name: 'ReportMention',
           foreign_key: 'mentioning_report_id',
           dependent: :destroy,
           inverse_of: :mentioning_report
  has_many :mentioning_reports,
           through: :sending_mentions,
           source: :mentioned_report
  has_many :receiving_mentions,
           class_name: 'ReportMention',
           foreign_key: 'mentioned_report_id',
           dependent: :destroy,
           inverse_of: :mentioned_report
  has_many :mentioned_reports,
           through: :receiving_mentions,
           source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentions
    saved = false

    transaction do
      saved = save
      create_mentions! if saved
    end

    saved
  end

  def update_with_mentions(attributes)
    updated = false

    transaction do
      updated = update(attributes)

      if updated
        sending_mentions.destroy_all
        create_mentions!
      end
    end

    updated
  end

  private

  def create_mentions!
    extracted_ids = content.to_s.scan(%r{#{MENTION_TARGET_DOMAIN}/reports/(\d+)}).flatten.map(&:to_i).uniq - [id]
    current_report_ids = Report.where(id: extracted_ids).pluck(:id)

    current_report_ids.each do |target_id|
      sending_mentions.create!(mentioned_report_id: target_id)
    end
  end
end
