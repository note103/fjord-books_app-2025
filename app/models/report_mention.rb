# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :mentioning_report, class_name: 'Report', inverse_of: :sending_mentions
  belongs_to :mentioned_report, class_name: 'Report', inverse_of: :receiving_mentions

  validates :mentioning_report_id, uniqueness: { scope: :mentioned_report_id }
end
