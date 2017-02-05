class Queries < ActiveRecord::Base



  def self.add_queries(data)
    puts "Request : #{data.parameters.inspect}"

    User.create! :username => data[:username],
                 :email => data[:email],
                 :message => data[:message],
                 :created_at => Date.now,
                 :updated_at => Date.now
  end



end