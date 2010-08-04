require "digest/sha1"

class User < ActiveRecord::Base
	has_many :items
	has_many :categories

   attr_accessor :password

	#	The following are needed if they are to be editted
   attr_accessible :name, :realname, :email, :info,
		:password, :password_confirmation

   validates_presence_of :name, :password, :password_confirmation
   validates_uniqueness_of :name
	validates_confirmation_of :password

	#	before_save works when it is an update or create
   def before_save
      self.hashed_password = User.hash_password(self.password)
   end

   def after_create
      @password = nil
   end

	def before_destroy
		self.items.destroy_all
		self.categories.destroy_all
	end

   def self.login(name, password)
      hashed_password = hash_password(password || "")
      self.find(:first, 
			:conditions => ["name = ? AND hashed_password = ?", name, hashed_password])
   end

   def try_to_login
      User.login(self.name, self.password)
   end

	def is_creatable_by?(creator_id)
		true
	end

	def is_destroyable_by?(destroyer_id)
		self.name != 'admin' && 
			destroyer_id == User.find( :first, 
				:conditions => ["name = ?", 'admin'] ).id
	end

	def is_editable_by?(editor_id)
		editor_id == self.id || 
			editor_id == User.find( :first, 
					:conditions => ["name = ?", 'admin'] ).id
	end

   private #--------------------

   def self.hash_password(password)
      Digest::SHA1.hexdigest(password)
   end
end
