require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
	fixtures :users

	def test_create
#		assert_difference('User.count',1){
			user = User.create(:name => 'name',:password => 'name', :password_confirmation => 'name')
			assert !user.new_record?
#		}
	end
end
