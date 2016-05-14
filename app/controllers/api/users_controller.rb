class Api::UsersController < ApplicationController
  #http_basic_authenticate_with :name => "myfinance", :password => "credit123"

  skip_before_filter :authenticate_user! # we do not need devise authentication here
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
    @users = User.find_by_email(params[:email])
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
    puts "Lets start the game..."
    @user = User.create_user(request);
    #@user = User.new(params[:user])
    #@user.temp_password = Devise.friendly_token
    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: :created }
        format.xml { render xml: @user, status: :created }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    puts "request = #{request}"
    puts "params[:id] = #{params[:id]}"
    User.find_by_email(params[:id]).destroy
    respond_to do |format|
      format.json { render json: params[:id].to_s() + 'deleted!', status: :ok }
    end
  end

  def delete
    puts "request = #{request}"
    puts "params[:id] = #{params[:id]}"
    User.find_by_email(params[:id]).destroy
    respond_to do |format|
      format.json { render json: params[:id].to_s() + 'deleted!', status: :ok }
    end
  end

  def send_mail
    puts "request = #{request}"
    User.send_forgot_password_mail(request);
    respond_to do |format|
      format.json { render json: @user, status: :ok }
      format.xml { render json: @user, status: :ok }
    end
  end

  def update_password
    puts "request = #{request}"
    User.update_password_for_user(request);
    respond_to do |format|
      format.json { render json: @user, status: :ok }
      format.xml { render json: @user, status: :ok }
    end
  end

  def update_service_token
    puts "request = #{request}"
    User.update_service_token_for_user(request);
    respond_to do |format|
      format.json { render json: @user, status: :ok }
      format.xml { render json: @user, status: :ok }
    end
  end

end
