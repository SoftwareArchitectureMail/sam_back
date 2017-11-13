class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :update, :destroy]

  # GET /notifications
  def index
    first_result = params['firstResult']
    max_result = params['maxResult']
    if (is_numeric(first_result) || first_result.nil?) && (is_numeric(max_result) || max_result.nil?)
      @notifications = Notification.all
      list_json = [
        "total": Notification.count,
        "list": @notifications
      ]
      render :json => list_json
      #render json: @notifications
    else
      render status: 406
    end
  end

  # Metodo para enviar notificaciones push
  def send_notification(username, sender)
    @devices = UserDevice.get_device_id(username)
    for i in @devices
      notification = HTTParty.post("https://fcm.googleapis.com/fcm/send",
      :body => {
        "to" => i.device_id,
        "notification" => {
          "body" => "Nuevo mensaje de "+sender,
          "title" => "Tienes un nuevo mensaje!",
          "icon" => "https://lh5.googleusercontent.com/8YRIsP7FC7ds-bF4mBQKdd8Y74R3hQkx57Z2A0im8WnP_b3W81HpyLC7yspIlDrE1VyltTTE3oEhgOk=w1366-h631"

        },
        "data" => {
          "body" => "Nuevo mensaje de "+sender,
          "title" => "Tienes un nuevo mensaje!",
          "icon" => "https://lh5.googleusercontent.com/8YRIsP7FC7ds-bF4mBQKdd8Y74R3hQkx57Z2A0im8WnP_b3W81HpyLC7yspIlDrE1VyltTTE3oEhgOk=w1366-h631"

        }
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        # Key de autorizacion para la app de android - Esto esta en mi cuenta de google <<jsbustosb@unal.edu.co>>
        'Authorization' => 'Key=AIzaSyCg0mjFzRqBnGDVv1k84_RHKYrxpIqHJVU'
      } )
    end
  end

  # GET /notifications/1
  def show
    render json: @notification
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      send_notification(@notification.username, @notification.sender)
      render status: :created
      #render json: @notification, status: :created, location: @notification
    else
      render status: :bad_request
      #render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      render status: 204
      #render json: @notification
    else
      render status: 406
      #render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
  end

  private

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render status: :bad_request
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    #@notification = Notification.find(params[:id])
    id = params[:id]
    if is_numeric(id)
      @notification = Notification.find(id)
    else
      render status: 406
    end
  end

  # Only allow a trusted parameter "white list" through.
  def notification_params
    params.require(:notification).permit(:username, :sender)
  end

  def is_numeric(o)
    true if Integer(o) rescue false
  end
end
