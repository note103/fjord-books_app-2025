# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前が登録されていたら名前が返される' do
    user = users(:alice)
    user.name = 'Alice'

    assert_equal 'Alice', user.name_or_email
  end

  test '名前が登録されていなければメールアドレスが返される' do
    user = users(:bob)

    user.name = nil
    assert_equal user.email, user.name_or_email

    user.name = ''
    assert_equal user.email, user.name_or_email
  end
end
