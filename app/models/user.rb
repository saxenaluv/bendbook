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
                 :password_confirmation_token => data[:password_confirmation_token],
                 :temp_password => data[:temp_password],
                 :active => data[:is_active],
                 :authorize => data[:is_authorize],
                 :contact_no => data[:contact_no],
                 :created_at => data[:created_at],
                 :updated_at => data[:updated_at]
  end

  def self.send_forgot_password_mail(data)
    puts "Request : #{data.parameters.inspect}"
    link = 'http://localhost:8000/index.html#/forgotPassword/' + data[:service_token]
    mail = Mail.new do
      body 'Dear BookStore User,'+ "\n\n" + 'Click on below link to reset your password.' + "\n\n"+ link + "\n\n" + 'Thank You' + "\n" + 'BookStore Team'
    end

    #Setting Mail contents
    mail['from'] = 'no-reply@bookstore.com'
    mail[:to] = data[:email]
    mail.subject = 'Forgot Password Link'

    puts "mail content : #{mail.inspect}"
    puts "mail Body : #{mail.body.inspect}"

    mail.delivery_method :sendmail
    mail.deliver
  end

  def self.send_default_mail(data)
    puts "Request : #{data.parameters.inspect}"

    mail = Mail.new do
      body 'Dear BookStore Team,'+ "\n\n" + 'User ' + data[:username] + ' has send below queries.' + "\n\n"+ data[:message] + "\n\n" + 'Thank You' + "\n" + 'BookStore Customer Care'
    end

    #Setting Mail contents
    mail['from'] = data[:email]
    mail[:to] = 'njain7242@gmail.com'
    mail.subject = '[Critical] Queries From User ' + data[:username]

    puts "mail content : #{mail.inspect}"
    puts "mail Body : #{mail.body.inspect}"

    mail.delivery_method :sendmail
    mail.deliver

    Queries.add_queries data


  end

  def self.update_password_for_user(data)
    puts "Request : #{data.parameters.inspect}"
    user = User.find_by_email(data[:email]);
    user.password = data[:password]
    user.password_confirmation_token = nil
    user.save!
  end

  def self.update_service_token_for_user(data)
    puts "Request : #{data.parameters.inspect}"
    user = User.find_by_email(data[:email]);
    user.password_confirmation_token = data[:service_token]
    user.save!
  end

end
