# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice)

    visit new_user_session_path
    fill_in 'Eメール', with: users(:alice).email
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end

  test '日報を作成する' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
    click_on '日報の新規作成'
    assert_selector 'h1', text: '日報の新規作成'

    fill_in 'タイトル', with: '日報を書くテスト'
    fill_in '内容', with: '日報を書くテストの内容です。'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'タイトル: 日報を書くテスト'
    assert_text '内容: 日報を書くテストの内容です。'
    assert_text '作成者: Alice'
  end

  test '日報を編集する' do
    visit report_path(@report)
    assert_selector 'h1', text: '日報の詳細'
    click_on 'この日報を編集'
    assert_selector 'h1', text: '日報の編集'

    fill_in 'タイトル', with: '日報を編集するテスト'
    fill_in '内容', with: '日報を編集するテストの内容です。'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'タイトル: 日報を編集するテスト'
    assert_text '内容: 日報を編集するテストの内容です。'
  end

  test '日報を削除する' do
    visit report_path(@report)
    assert_selector 'h1', text: '日報の詳細'
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_selector 'h1', text: '日報の一覧'
    assert_no_link @report.title, href: report_path(@report)
  end

  test '他の日報へのリンクを日報に記載すると、言及先の日報に言及元へのリンクが表示される' do
    mentioned_report = reports(:bob)

    visit new_report_path
    assert_selector 'h1', text: '日報の新規作成'

    fill_in 'タイトル', with: '他の日報へのリンクを記載するテスト'
    fill_in '内容', with: "他の日報へのリンクを記載します。http://localhost:3000/reports/#{mentioned_report.id}"
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text "他の日報へのリンクを記載します。http://localhost:3000/reports/#{mentioned_report.id}"

    visit report_path(mentioned_report)
    assert_selector 'h1', text: '日報の詳細'
    assert_link '他の日報へのリンクを記載するテスト'
  end

  test '他の日報へのリンクを削除すると、言及先の日報から言及元へのリンクが消える' do
    mentioning_report = reports(:alice)
    mentioned_report = reports(:bob)
    mentioning_report.update!(content: "http://localhost:3000/reports/#{mentioned_report.id}")

    visit report_path(mentioned_report)
    assert_text mentioning_report.title

    visit report_path(mentioning_report)
    assert_selector 'h1', text: '日報の詳細'

    click_on 'この日報を編集'
    assert_selector 'h1', text: '日報の編集'

    fill_in '内容', with: '他の日報へのリンクを削除します。'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '他の日報へのリンクを削除します。'

    visit report_path(mentioned_report)
    assert_selector 'h1', text: '日報の詳細'
    assert_no_link mentioning_report.title, href: report_path(mentioning_report)
    assert_text '（この日報に言及している日報はまだありません）'
  end
end
