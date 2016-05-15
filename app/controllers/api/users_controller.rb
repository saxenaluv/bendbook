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
  #Generic GET for user
  def index

    if params.nil?
      raise "Params Not passed"
    end

    conditions = get_params(params,[:id, :first_name, :last_name, :email, :password, :password_confirmation_token, :active, :contact_no])
    conditions[:id] = params[:id].split ',' if !params[:id].nil?
    conditions[:first_name] = params[:first_name].split ',' if !params[:first_name].nil?
    conditions[:last_name] = params[:last_name].split ',' if !params[:last_name].nil?
    conditions[:email] = params[:email].split ',' if !params[:email].nil?
    conditions[:password] = params[:password].split ',' if !params[:password].nil?
    conditions[:password_confirmation_token] = params[:password_confirmation_token].split ',' if !params[:password_confirmation_token].nil?
    conditions[:active] = params[:active].split ',' if !params[:active].nil?
    conditions[:contact_no] = params[:contact_no].split ',' if !params[:contact_no].nil?

    hash = params[:hash].split ',' if !params[:hash].nil?

    p "Users = #{conditions}"

    begin
      user = User.where(conditions).first
    rescue ActiveRecord::RecordNotFound => e
      user = []
    end

    p "User : #{user.inspect}"

    if hash
      res = {
          :id => user.id,
          :email => user.email,
          :hash_value => user.password,
          :active => user.active,
          :authorize => user.authorize
      }
    else
      res = {
          :id => user.id,
          :first_name => user.first_name,
          :email => user.email,
          :contact_no => user.contact_no
      }
    end

    p "index"
    render json: res, status: :ok
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

  private
  def get_params params,fields
    res = {}
    fields.each do |f|
      res[f] = params[f] if params[f]
    end
    res
  end

end
