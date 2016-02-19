class User < ActiveRecord::Base
  #validates :email, :first_name, :last_name, :presence =>true
  #validates_uniqueness_of :email

  #def self.get_user_id(emailId)
  #  p "User.find_by_email(emailId) = #{User.find_by_id(emailId)}"
  #    User.find_by_id(emailId).id
  #
  #  end

end