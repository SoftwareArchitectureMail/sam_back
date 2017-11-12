class UserDevicesController < ApplicationController
  before_action :set_user_device, only: [:show, :update, :destroy]

  # GET /user_devices
  def index
    first_result = params['firstResult']
    max_result = params['maxResult']
    if (is_numeric(first_result) || first_result.nil?) && (is_numeric(max_result) || max_result.nil?)
      @user_devices = UserDevice.all
      list_json = [
        "total": UserDevice.count,
        "list": @user_devices
      ]
      render :json => list_json
      #render json: @user_devices
    else
      render status: 406
    end
  end

  # GET /user_devices/1
  def show
    render json: @user_device
  end

  # POST /user_devices
  def create
    @user_device = UserDevice.new(user_device_params)
    if @user_device.save
      render status: :created
      #render json: @user_device, status: :created, location: @user_device
    else
      render status: :bad_request
      #render json: @user_device.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_devices/1
  def update
    if @user_device.update(user_device_params)
      render status: 204
      #render json: @user_device
    else
      render status: 406
      #render json: @user_device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_devices/1
  def destroy
    @user_device.destroy
  end

  private

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render status: :bad_request
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_user_device
      #@user_device = UserDevice.find(params[:id])
      id = params[:id]
      if is_numeric(id)
        @user_device = UserDevice.find(id)
      else
        render status: 406
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_device_params
      params.require(:user_device).permit(:username, :device_id)
    end

    def is_numeric(o)
      true if Integer(o) rescue false
    end
end
