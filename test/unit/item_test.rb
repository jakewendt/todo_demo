require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
	fixtures :items

	def test_create
#		assert_difference('Item.count',1){
			item = Item.create(:name => 'name')
			assert !item.new_record?
#		}
	end
end
