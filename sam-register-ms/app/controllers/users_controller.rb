require 'digest'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_user_username, only: [:login, :show_username]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /user/username
  def show_username
    if @user.blank?
      render status: 404
    else
      render json: @user
    end
  end


  # POST /users
  def create
    params[:username].downcase!
    @user = User.new(user_params)
    @user.password = Digest::SHA256.hexdigest(params[:password])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
      @user.password = Digest::SHA256.hexdigest(params[:password])
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    render status: 404 if @user.blank?
    @user.destroy
    render status: 200
  end

  def login
    if @user.blank?
      render status: 404
    else
      if @user.password == Digest::SHA256.hexdigest(params[:password])
        render json: @user, status: 200
      else
        render status: 401
      end
    end
  end

  private

    def set_user_username
      @user = User.find_by_username(params[:username])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password, :gender, :date_birth, :mobile_phone, :current_email, :location)
    end
end
