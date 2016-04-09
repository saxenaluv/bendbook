class Api::BooksController < ApplicationController
  require 'multipart_parser/reader'
  #http_basic_authenticate_with :name => "myfinance", :password => "credit123"

  before_filter :fetch_user, :except => [:create]
  after_filter :add_headers

DEFAULT_IMG_PATH = File.expand_path("../../../book_image-not-available.gif")

def fetch_user
    @books = Book.where(:user_id => params[:user_id]).all
end

  def add_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, PUT'
  end

  #For queries like /books? Generic query
  def index
    @books = Book.where(:user_id => params[:user_id], :is_sold => false)
    arr = []
    @books.each do |book|
      arr <<
          {
              :id => book.id,
              :title => book.title,
              :author => book.author,
              :edition => book.edition,
              :type => book.book_type,
              :city => book.city,
              :location => book.location,
              :institute => book.institute,
              :post_for => book.post_for,
              :market_price => book.market_price,
              :img_data => Base64.encode64(book.img),
              :special_note => book.special_note,
              :description => book.description,
              :category => book.category,
              :views => book.views
          }
    end

    p "index"
    render json: arr, status: :ok
    #respond_to do |format|
    #  p format.inspect
    #  format.json { render json: {success : true} }
    #end
  end

#For queries like /books/{id}
  def show



    book = Book.find_by_id(params[:id])

    if(book.img == nil || book.img == '')
      image = File.open(DEFAULT_IMG_PATH, 'rb') {|file| file.read }
      book.img = image
    end

    b1 = {
                  :id => book.id,
                  :title => book.title,
                  :author => book.author,
                  :edition => book.edition,
                  :type => book.book_type,
                  :city => book.city,
                  :location => book.location,
                  :institute => book.institute,
                  :post_for => book.post_for,
                  :market_price => book.market_price,
                  :img_data => Base64.encode64(book.img),
                  :special_note => book.special_note,
                  :description => book.description,
                  :views => book.views,
                  :category => book.category
              }

    #Return no. of views also

    render json: b1, status: :ok

  end




def create
  mp = parse_multi_params(request)
  puts "mp = #{mp.inspect}"
  puts "Lets create the books"
  if(mp[:file].is_a?(Array) )
    mp[:file] = mp[:file].join;
  end

  if(mp[:file] == nil || mp[:file] == '')
    image = File.open(DEFAULT_IMG_PATH, 'rb') {|file| file.read }
    mp[:file] = image
  end


  book = Book.persist(mp)

  #puts "What are the books = #{Book.all}"
  puts "Book = "
  puts "#{book}"

  response = {
                :id => book.id,
                :title => book.title,
                :author => book.author,
                :edition => book.edition,
                :type => book.book_type,
                :city => book.city,
                :location => book.location,
                :institute => book.institute,
                :post_for => book.post_for,
                :market_price => book.market_price,
                :img_data => Base64.encode64(book.img),
                :special_note => book.special_note,
                :description => book.description
 }

  render json: response , status: :created

end



    def parse_multi_params(request)
      parts={}
      puts "request.headers['CONTENT_TYPE'] = #{request.headers['CONTENT_TYPE']}"
      reader = MultipartParser::Reader.new(MultipartParser::Reader::extract_boundary_value(request.headers['CONTENT_TYPE']))

      reader.on_part do |part|
        pn = part.name.to_sym
        part.on_data do |partial_data|
          if parts[pn].nil?
            parts[pn] = partial_data
          else
            parts[pn] = [parts[pn]] unless parts[pn].kind_of?(Array)
            parts[pn] << partial_data
          end
        end
      end

      reader.write request.raw_post
      reader.ended? or raise Exception, 'truncated multipart message'

      parts
    end

  def destroy
    puts "request = #{request}"
    puts "params[:id] = #{params[:id]}"
    book = Book.find_by_id(params[:id])
    book.is_sold = true
    book.save!
    respond_to do |format|
        format.json { render json: nil, status: :ok }
    end
  end

  def is_sold
      puts "request = #{request}"
      puts "params[:id] = #{params[:id]}"
      book = Book.find_by_id(params[:id])
      book.is_sold = true
      book.save!
      respond_to do |format|
          format.json { render json: nil, status: :ok }
      end
  end

  def update_views
    puts "update_views = #{request}"
    book = Book.find_by_id(params[:id])
    book.views = book.views + 1
    book.save!
    respond_to do |format|
        format.json { render json: nil, status: :ok }
    end
  end





end
