# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '日報の作成者なら編集可能であることが返される' do
    alice_user = users(:alice)
    alice_report = reports(:alice)

    assert alice_report.editable?(alice_user)
  end

  test '日報の作成者でなければ編集不可能であることが返される' do
    bob_user = users(:bob)
    alice_report = reports(:alice)

    assert_not alice_report.editable?(bob_user)
  end

  test '日報の作成日時から年月日が返される' do
    report = Report.new(created_at: Time.zone.parse('2026-09-01 10:00:00'))
    assert_equal Date.new(2026, 9, 1), report.created_on
  end

  test '日報内に他の日報へのリンクが含まれていると言及リストに登録される' do
    mentioning_report = reports(:alice)
    mentioned_report = reports(:bob)

    mentioning_report.update!(
      content: "ボブの日報を読みました。http://localhost:3000/reports/#{mentioned_report.id}"
    )

    assert_includes mentioning_report.mentioning_reports, mentioned_report
  end

  test '日報内に他の日報へのリンクが含まれていると言及先からも言及元が参照できる' do
    mentioning_report = reports(:alice)
    mentioned_report = reports(:bob)

    mentioning_report.update!(
      content: "ボブの日報を読みました。http://localhost:3000/reports/#{mentioned_report.id}"
    )

    assert_includes mentioned_report.mentioned_reports, mentioning_report
  end

  test '日報内で他の日報へのリンクが削除されると言及リストから除外される' do
    mentioning_report = reports(:alice)
    mentioned_report = reports(:bob)

    mentioning_report.update!(
      content: "ボブの日報を読みました。http://localhost:3000/reports/#{mentioned_report.id}"
    )

    assert_includes mentioning_report.mentioning_reports, mentioned_report

    mentioning_report.update!(
      content: 'ボブの日報へのリンクを削除しました。'
    )

    mentioning_report.reload
    assert_not_includes mentioning_report.mentioning_reports, mentioned_report
  end

  test '他の日報へのリンクを複数記載しても1つ分しか言及リストに登録されない' do
    mentioning_report = reports(:alice)
    mentioned_report = reports(:bob)

    mentioning_report.update!(
      content: <<~CONTENT
        ボブの日報を読みました。
        http://localhost:3000/reports/#{mentioned_report.id}
        もう一度ボブの日報を読みました。
        http://localhost:3000/reports/#{mentioned_report.id}
      CONTENT
    )

    assert_includes mentioning_report.mentioning_reports, mentioned_report
    assert_equal 1, mentioning_report.mentioning_reports.count
  end

  test 'その日報自体のリンクを記載しても言及リストに登録されない' do
    report = reports(:alice)

    report.update!(
      content: "この日報を読みました。http://localhost:3000/reports/#{report.id}"
    )

    assert_not_includes report.mentioning_reports, report
  end
end
