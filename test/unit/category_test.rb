require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
	fixtures :categories

	def test_create
#		assert_difference('Category.count',1){
			category = Category.create(:name => 'name')
			assert !category.new_record?
#		}
	end
end
