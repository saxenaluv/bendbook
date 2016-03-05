class User < ActiveRecord::Base
  #validates :email, :first_name, :is_active, :contact_no =>true
  validates_uniqueness_of :email

  def self.get_user_id(emailId)
    p "User.find_by_email(emailId) = #{User.find_by_email(emailId)}"
      User.find_by_email(emailId).id
    end

  def self.create_user(data)
    puts "Request : #{data.parameters.inspect}"

    User.create! :first_name => data[:first_name],
                 :last_name => data[:last_name],
                 :email => data[:email],
                 :password => data[:password],
                 :password_confirmation => data[:confirm_password],
                 :temp_password => data[:temp_password],
                 :active => data[:is_active],
                 :contact_no => data[:contact_no],
                 :created_at => data[:created_at],
                 :updated_at => data[:updated_at]
  end


end