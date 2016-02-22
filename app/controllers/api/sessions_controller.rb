class Api::SessionsController < ApplicationController
  #http_basic_authenticate_with :name => "myfinance", :password => "credit123"

  skip_before_filter :authenticate_user! # we do not need devise authentication here
  before_filter :fetch_session, :except => [:index, :create]
  after_filter :add_headers



  def fetch_session
    @sessions = Session.find_by_user_id(params[:user_id])
  end

  def add_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, PUT'
  end

  #For queries like /sessions? Generic query
  def index
    @sessions = Session.find_by_user_id(params[:user_id])
    p "index"
    respond_to do |format|
      p format.inspect
      format.json { render json: @sessions }
    end
  end

  #For queries like /sessions/{id}
  def show
    respond_to do |format|
      format.json { render json: @sessions }

    end
  end

  def create
    puts "Lets start the game..."
    @sessions = Session.create_session_for_user(request);
    respond_to do |format|
      if @sessions.save
        format.json { render json: @sessions, status: :created }
        format.xml { render xml: @sessions, status: :created }
      else
        format.json { render json: @sessions.errors, status: :unprocessable_entity }
        format.xml { render xml: @sessions.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sessions.update_attributes(params[:session])
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @sessions.errors, status: :unprocessable_entity }
        format.xml { render xml: @sessions.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @sessions.destroy
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @sessions.errors, status: :unprocessable_entity }
        format.xml { render xml: @sessions.errors, status: :unprocessable_entity }
      end
    end
  end
end