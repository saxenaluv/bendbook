class Book < ActiveRecord::Base
  #validates :title, :author, :presence =>true
  #validates_uniqueness_of :email

  def self.persist(data)
    puts "Lets print all books "
    puts "#{Book.all}"
    Book.create! :title => data[:title],
                 :author => data[:author],
                 :img => data[:file]




  end


end