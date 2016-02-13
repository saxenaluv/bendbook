class Api::BooksController < ApplicationController
  require 'multipart_parser/reader'
  #http_basic_authenticate_with :name => "myfinance", :password => "credit123"



  before_filter :fetch_user, :except => [:index, :create]
  after_filter :add_headers



def fetch_user
    @user = User.find_by_id(params[:id])
end

  def add_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, PUT'
  end

  #For queries like /user? Generic query
  def index
    @users = User.find_by_email(params[:email_id])
    p "index"
    respond_to do |format|
      p format.inspect
      format.json { render json: @users }
    end
  end

#For queries like /user/{id}
  def show
    respond_to do |format|
      format.json { render json: @user }

    end
  end




def create
  mp = parse_multi_params(request)
  puts "mp = #{mp.inspect}"
  puts "Lets create the books"
     #process_params(mp[:t])
    p params.inspect
    respond_to do |format|
    if true
      format.json { render json: @user, status: :created }
      format.xml { render xml: @user, status: :created }
    else
      format.json { render json: @user.errors, status: :unprocessable_entity }
      format.xml { render xml: @user.errors, status: :unprocessable_entity }
    end
  end

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



end
