# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前が登録されていたら名前が返される' do
    user = User.new(name: 'Alice', email: 'alice@example.com')
    assert_equal 'Alice', user.name_or_email
  end

  test '名前が登録されていなければメールアドレスが返される' do
    user = User.new(name: nil, email: 'bob@example.com')
    assert_equal 'bob@example.com', user.name_or_email

    user = User.new(name: '', email: 'carol@example.com')
    assert_equal 'carol@example.com', user.name_or_email
  end
end
