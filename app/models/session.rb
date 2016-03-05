class Session < ActiveRecord::Base
  validates :user_id, :session_token, :email, :presence =>true
  validates_uniqueness_of :user_id

  def self.create_session_for_user(data)
    puts "Request : #{data.parameters.inspect}"

    Session.create! :user_id => data[:user_id],
                    :session_token => data[:session_token],
                    :email => data[:email]
  end

  def self.delete_session_for_use(data)
    puts "Request : #{data.parameters.inspect}"

    Session.delete!
  end
end