require 'test_helper'

class FakeRequest < Struct.new(:path_info, :params)
end

class MappingTest < ActiveSupport::TestCase
  def fake_request(path, params={})
    FakeRequest.new(path, params)
  end

  test 'store options' do
    mapping = Devise.mappings[:user]
    assert_equal User,                mapping.to
    assert_equal User.devise_modules, mapping.modules
    assert_equal :users,              mapping.plural
    assert_equal :user,               mapping.singular
    assert_equal "users",             mapping.path
  end

  test 'allows path to be given' do
    assert_equal "admin_area", Devise.mappings[:admin].path
  end

  test 'allows custom singular to be given' do
    assert_equal "accounts", Devise.mappings[:manager].path
  end

  test 'has strategies depending on the model declaration' do
    assert_equal [:rememberable, :token_authenticatable, :database_authenticatable], Devise.mappings[:user].strategies
    assert_equal [:database_authenticatable], Devise.mappings[:admin].strategies
  end

  test 'find scope for a given object' do
    assert_equal :user, Devise::Mapping.find_scope!(User)
    assert_equal :user, Devise::Mapping.find_scope!(:user)
    assert_equal :user, Devise::Mapping.find_scope!(User.new)
  end

  test 'find scope works with single table inheritance' do
    assert_equal :user, Devise::Mapping.find_scope!(Class.new(User))
    assert_equal :user, Devise::Mapping.find_scope!(Class.new(User).new)
  end

  test 'find scope raises an error if cannot be found' do
    assert_raise RuntimeError do
      Devise::Mapping.find_scope!(String)
    end
  end

  test 'return default path names' do
    mapping = Devise.mappings[:user]
    assert_equal 'sign_in',      mapping.path_names[:sign_in]
    assert_equal 'sign_out',     mapping.path_names[:sign_out]
    assert_equal 'password',     mapping.path_names[:password]
    assert_equal 'confirmation', mapping.path_names[:confirmation]
    assert_equal 'sign_up',      mapping.path_names[:sign_up]
    assert_equal 'unlock',       mapping.path_names[:unlock]
  end

  test 'allow custom path names to be given' do
    mapping = Devise.mappings[:manager]
    assert_equal 'login',        mapping.path_names[:sign_in]
    assert_equal 'logout',       mapping.path_names[:sign_out]
    assert_equal 'secret',       mapping.path_names[:password]
    assert_equal 'verification', mapping.path_names[:confirmation]
    assert_equal 'register',     mapping.path_names[:sign_up]
    assert_equal 'unblock',      mapping.path_names[:unlock]
  end

  test 'magic predicates' do
    mapping = Devise.mappings[:user]
    assert mapping.authenticatable?
    assert mapping.confirmable?
    assert mapping.recoverable?
    assert mapping.rememberable?
    assert mapping.registerable?

    mapping = Devise.mappings[:admin]
    assert mapping.authenticatable?
    assert mapping.recoverable?
    assert mapping.lockable?
    assert_not mapping.confirmable?
    assert_not mapping.rememberable?
  end
end
