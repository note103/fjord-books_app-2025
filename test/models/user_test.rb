# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前が登録されていたら名前が返される' do
    alice_user = users(:alice)
    alice_user.update!(name: 'Alice')

    assert_equal 'Alice', alice_user.name_or_email
  end

  test '名前が登録されていなければメールアドレスが返される' do
    bob_user = users(:bob)
    bob_user.update!(name: nil, email: 'bob@example.com')

    assert_not_equal 'Bob', bob_user.name_or_email
    assert_equal 'bob@example.com', bob_user.name_or_email
  end
end
