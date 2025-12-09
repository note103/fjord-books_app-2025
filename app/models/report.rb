# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions, dependent: :destroy, inverse_of: :report
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report
  has_many :reverse_report_mentions, class_name: 'ReportMention', foreign_key: :mentioned_report_id, dependent: :destroy,
                                     inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :reverse_report_mentions, source: :report

  alias_attribute :content, :body

  validates :title, presence: true
  validates :content, presence: true

  after_save :sync_report_mentions, if: -> { saved_change_to_body? }

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  MENTION_URL_REGEX = %r{http://localhost:3000/reports/(\d+)}i

  def sync_report_mentions
    ids = extract_mentioned_report_ids
    ReportMention.transaction do
      report_mentions.where.not(mentioned_report_id: ids).delete_all

      existing_ids = report_mentions.pluck(:mentioned_report_id)
      (ids - existing_ids).each do |mentioned_id|
        report_mentions.create!(mentioned_report_id: mentioned_id)
      end
    end
  end

  def extract_mentioned_report_ids
    return [] if content.blank?

    ids = content.scan(MENTION_URL_REGEX).flatten.map(&:to_i).uniq
    ids -= [id]

    Report.where(id: ids).pluck(:id)
  end
end
