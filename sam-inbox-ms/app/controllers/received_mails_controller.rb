class ReceivedMailsController < ApplicationController
  before_action :set_received_mail, only: [:show, :update, :destroy]

  def getbyuser
    @received_mails = ReceivedMail.where(recipient: params[:recipient])
    render json: @received_mails
  end

  # GET /received_mails
  def index
    #puts "USUARIO: #{params[:username]}"
    @rm = ReceivedMail.where(recipient: params[:username])
    @rm = @rm.by_sender(params[:sender]) if params.has_key?(:sender)
    @rm = @rm.by_read(params[:read]) if params.has_key?(:read)
    @rm = @rm.by_urgent(params[:urgent]) if params.has_key?(:urgent)
    if (params.has_key?(:page) && params.has_key?(:per_page))
      @rm = @rm.paginate(page: params[:page], per_page: params[:per_page]).order('created_at DESC')
    else
      @rm = @rm.paginate(page: 1, per_page: 10).order('created_at DESC')
    end
    @rm.each do |mail|
      mail.message_body = mail.message_body[0..9]
    end
    render json: @rm.to_json(:only => [ :id, :sender, :subject, :message_body, :attachment, :created_at, :read, :urgent])
  end

  # GET /received_mails/1
  def show
    render json: @received_mail
  end

  # POST /received_mails
  def create
    @received_mail = ReceivedMail.new(received_mail_params)

    if @received_mail.save
      render json: @received_mail, status: :created, location: @received_mail
    else
      render json: @received_mail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /received_mails/1
  def update
    if @received_mail.update(read_param)
      render json: @received_mail
    else
      render json: @received_mail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /received_mails/1
  def destroy
    @received_mail.destroy
  end

  # GET /inbox/sender/nombre
  def by_sender
    @received_mails = ReceivedMail.where(sender: params[:sender], recipient: params[:recipient])
    if @received_mails.blank?
      #render plain: "Not mails from " + params[:sender].to_s + " found", status: 404
      render json: {message: "Not mails from " + params[:sender].to_s + " found", status: 404}, status:404
      return 1
    end
    render json: @received_mails
  end

  # GET /inbox/read
  def read
    @received_mails = ReceivedMail.where(read: true, recipient: params[:recipient])
    if @received_mails.blank?
      render json: {message: "Not read mails found", status: 404}, status:404
      return 1
    end
    render json: @received_mails
  end

  # GET /inbox/unread
  def unread
    @received_mails = ReceivedMail.where(read: false, recipient: params[:recipient])
    if @received_mails.blank?
      render json: {message: "Not unread mails found", status: 404}, status:404
      return 1
    end
    render json: @received_mails
  end

  # GET /inbox/urgent
  def urgent
    @received_mails = ReceivedMail.where(urgent: true, recipient: params[:recipient])
    if @received_mails.blank?
      render json: {message: "Not urgent mails found", status: 404}, status:404
      return 1
    end
    render json: @received_mails
  end

  # GET /inbox/not_urgent
  def not_urgent
    @received_mails = ReceivedMail.where(urgent: false, recipient: params[:recipient])
    render json: @received_mails
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_received_mail
      @received_mail = ReceivedMail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def received_mail_params
      params.require(:received_mail).permit(:sender, :recipient, :cc, :distribution_list, :subject, :message_body, :attachment, :sent_date, :read, :urgent)
    end

    def read_param
      params.require(:received_mail).permit(:read)
    end
end
