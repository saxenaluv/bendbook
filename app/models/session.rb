class Session < ActiveRecord::Base
  validates :user_id, :session_token, :presence =>true

  def self.create_session_for_user(data)
    puts "Request : #{data.parameters.inspect}"

    Session.create! :user_id => data[:user_id],
                    :session_token => data[:session_token],
                    :email => data[:email]
  end
end