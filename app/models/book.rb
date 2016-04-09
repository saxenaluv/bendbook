class Book < ActiveRecord::Base

  #validates :title, :author, :presence =>true
  #validates_uniqueness_of :email

  def self.persist(data)
    puts "Lets print all books "

    book = Book.create! :title => data[:title],
                 :author => data[:author],
                 :edition => data[:edition],
                 :market_price => data[:mrp_price],
                 :selling_price => data[:selling_price],
                 :institute => data[:institute],
                 :location => data[:location],
                 :city => data[:city],
                 :book_type => data[:type],
                 :post_for => data[:sellingType],
                 :edition => data[:edition],
                 :img => data[:file],
                 :special_note => data[:specialNote],
                 :user_id => data[:user_id],
                 :description => data[:description],
                 :category => data[:category]

    puts "book = #{book}"

    return book;

  end




end