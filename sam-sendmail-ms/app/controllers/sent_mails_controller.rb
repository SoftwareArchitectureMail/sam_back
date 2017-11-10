class SentMailsController < ApplicationController
  before_action :set_sent_mail, only: [:show, :update, :destroy]

  # GET /sent_mails
  def index
    sent_mails=SentMail.sent(params)
    sent_mails.each do |mail|
      mail.subject = mail.subject
      mail.message_body = mail.message_body
    end
    render json: sent_mails.to_json(:only => [ :id, :subject,:recipient, :message_body, :draft, :urgent, :sent_date, :attachment ])
  end

  # GET /sent_mails/1
  def show
    sent_mail=SentMail.sentId(params)
    if sent_mail.nil?
      render status: 404
    else
      render json: sent_mail.to_json
    end
  end

  # GET /drafts
  def draft_index
    drafts = SentMail.drafts(params)
    drafts.each do |draft|
      draft.subject = draft.subject[0..24]+'.'
      draft.message_body = draft.message_body[0..40]+'...'
      if draft.attachment.file.nil?
        draft.attachment=false
      else
        draft.attachment=true
      end
    end
    render json: drafts.to_json(:only => [ :id, :subject,:recipient, :message_body, :draft, :urgent, :created_at, :attachment])
  end

# GET /drafts/1
  def draft_show
      draft = SentMail.draftsId(params)
      if draft.nil?
        render status: 404
      else
        render json: draft.to_json
      end
  end

  # POST /sent_mails
  def create
    sent_mail = SentMail.new(sent_mail_params)
    if sent_mail.subject == "" or sent_mail.subject.nil?
      sent_mail.subject.update_attributes(subject:"(sin asunto)")
    end
    if sent_mail.save
      render json: sent_mail, status: :created
    else
      render json: sent_mail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sentdraft
def sent_draft
  @draft=SentMail.draftsId(params)
  if @draft.update_attributes(draft: params[:draft])
    render json: @draft
  else
    render json: @draft.errors, status: :unprocessable_entity
  end
end

  # PATCH/PUT /drafts/1
  def modify_draft
    @update_mail=SentMail.find(params[:id])
    if @update_mail.update_attributes(
      draft: false)
      render json: @update_mail
    else
      render json: @update_mail.errors, status: :unprocessable_entity
    end
  end


  # DELETE /sent_mails/1
  def destroy
    SentMail.sentId(params).destroy
    render status: 200
  end

  # DELETE /drafts/1
  def delDraft
    SentMail.draftsId(params).destroy
    render status: 200
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sent_mail
    @sent_mail = SentMail.sentId(params)
  end

  # Only allow a trusted parameter "white list" through.
  def sent_mail_params
    params.require(:sent_mail).permit(:sender, :recipient, :cc, :distribution_list, :subject, :message_body, :attachment, :sent_date, :draft, :urgent, :confirmation)
  end
end
