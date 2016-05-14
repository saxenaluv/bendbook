class Session < ActiveRecord::Base
  validates :user_id, :session_token, :email, :presence =>true
  validates_uniqueness_of :user_id

  def self.create_session_for_user(data)
    puts "Request : #{data.parameters.inspect}"

    Session.create! :user_id => data[:user_id],
                    :session_token => data[:session_token],
                    :email => data[:email],
                    :is_fb_user => data[:is_fb_user]
  end

  def self.update_session_for_user(data)
    puts "Request : #{data.parameters.inspect}"
    session = Session.find_by_user_id(data [:user_id]);

    if session.nil?
        Session.create! :user_id => data[:user_id],
                        :session_token => data[:new_session_token],
                        :email => 'fbuser@test.com',
                        :is_fb_user => true
    else
      session.session_token = data[:new_session_token]
      session.save!
    end

  end

  def self.delete_session_for_use(data)
    puts "Request : #{data.parameters.inspect}"

    Session.delete!
  end
end