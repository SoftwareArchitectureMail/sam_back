class MailController < ApplicationController

skip_before_action :validate_token, only: :send_drafts
# POST /sent_mails  - sendMail
  def sendMail
    @sentMail = HTTParty.post(ms_ip("sm")+"/sent",ParamsHelper.send_mail_params(params, @username))
    if @sentMail.code == 201
      render status: 201, json: @sentMail.to_json
      #TO_DO Si el mensaje se envía (NO ES BORRADOR) se guarda en la base de inbox de usuario que recibe
      unless params[:draft]
        @receivedMail = HTTParty.post(ms_ip("in")+"/received_mails", ParamsHelper.inbox_params(params, @username))
        @sendnotification = HTTParty.post(ms_ip("nt")+"/notifications", { body: {
          username: params[:recipient],
          sender: @username
        }.to_json,headers: {
          'Content-Type': 'application/json'
          }})
      end
      # TO_DO Si el mensaje se le pone una fecha de envío se programa su envio
      # Si no se pone fecha de envío se envía de una vez y no es borrador
      if params[:sent_date] != ""
        idMensaje = JSON.parse(@sentMail.body)["id"]
        @scheduledMail = HTTParty.post(ms_ip("schs")+"/scheduledsending/add", {
          body: {
            user_id: @username,
            mail_id: idMensaje,
            date: params[:sent_date]
          }.to_json,
          headers:{
            'Content-Type': 'application/json'
          }
          })
      end
    else
      render json: {messsage: "Error, mail couldn't be sent or saved"}
    end

  end

  def send_drafts
     @sent_draft = HTTParty.put(ms_ip("sm")+"/sentdraft/"+params[:id].to_s)
     if @sent_draft.code == 200
       mail_draft=JSON.parse(@sent_draft.body)
       mail2 = {
           body: {
           :sender => mail_draft['sender'],
           :recipient => mail_draft['recipient'],
           :cc => mail_draft['cc'],
           :distribution_list => mail_draft['distribution_list'],
           :subject => mail_draft['subject'],
           :message_body => mail_draft['message_body'],
           :attachments => mail_draft['attachment'],
           :sent_dateTime => mail_draft['sent_date'],
           :urgent => mail_draft['urgent'],
           :read => false
           }.to_json,
           :headers => {
           'Content-Type' => 'application/json'
           }
           }
       receivedMail = HTTParty.post(ms_ip("in")+"/received_mails", mail2)
       render status: 200, json: @sent_draft.body
     else
       render status: 404, json: {body:{message: "Draft wasn't modify"}}.to_json
     end
   end
  #PUT
  def modify_draft
    data={
      recipient: params[:recipient],
      cc: params[:cc],
      distribution_list: params[:distribution_list],
      subject: params[:subject],
      message_body: params[:message_body],
      attachment: params[:attachment],
      sent_date: params[:sent_date],
      urgent: params[:urgent],
      draft: params[:draft],
      confirmation: params[:confirmation]
    }
    @modifyDraft = HTTParty.put(ms_ip("sm")+"/draft/"+params[:id].to_s,body:data.to_json,query:{sender:@username},
    headers: { "Content-Type": 'application/json'})
    if @modifyDraft.code == 200
      render status: 200, json: @modifyDraft.body
    else
      render status: 404, json: {body:{message: "Draft wasn't modify"}}.to_json
    end
  end

  # GET /sent_mails - sentMails
  def sent
    @sentMails = getAllSentMails
    if @sentMails.code == 200
      render status: 200, json: @sentMails.body
    else
      render status: 404, json: {body:{message: "Sent Mails not found"}}.to_json
    end
  end

    # GET /sent_mails/1   - sentMails/1
  def sent_mail
    @sentMail = checkSentMail(params[:id])
    if @sentMail.code == 200
      render status: 200, json: @sentMail.body
    else
      render status: 404, json: {body:{message: "Sent Mail not found"}}.to_json
    end
  end

    # GET /sent_mails/drafts - drafts
  def draft_index
    drafts=''
    if params[:urgent]
      drafts = HTTParty.get(ms_ip("sm")+"/draft/",query:{sender:@username,urgent:params[:urgent]})
    else
      drafts = HTTParty.get(ms_ip("sm")+"/draft/",query:{sender:@username})
    end
    if drafts.code == 200
      render status: 200, json: drafts.body
    else
      render status: 404, json: {body:{message: "Drafts not found"}}.to_json
    end
  end

  def draft_show
    draft=HTTParty.get(ms_ip("sm")+"/draft/"+params[:id].to_s,query:{sender:@username})
    if draft.code == 200
      render status: 200, json: draft.body
    else
      render status: 404, json: {body:{message: "Draft not found"}}.to_json
    end
  end

  # DELETE
  def destroy_sent
    @resp = HTTParty.delete(ms_ip("sm")+"/sent/"+params[:id].to_s,query:{sender:@username})
    if @resp.code == 200
      render status: 200, json: {body:{message: "Sent mail deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Sent mail couldn't be deleted"}}.to_json
    end
  end

    #DELETE
  def destroy_draft
    @resp = HTTParty.delete(ms_ip("sm")+"/draft/"+params[:id].to_s,query:{sender:@username})
    if @resp.code == 200
      render status: 200, json: {body:{message: "Draft deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Draft couldn't be deleted"}}.to_json
    end
  end

  def getAllSentMails
    unless params[:urgent]
      return HTTParty.get(ms_ip("sm")+"/sent",query:{sender:@username})
    end
    return HTTParty.get(ms_ip("sm")+"/sent",query:{sender:@username,urgent:params[:urgent]})
  end

  def checkSentMail(id)
    results = HTTParty.get(ms_ip("sm")+"/sent/"+id.to_s,query:{sender:@username})
    return results
  end

  #inbox methods
  def inbox
    params.permit!
    query = params.except(:action, :controller)
    query.permit!
    #puts "THIS IS: " + query.to_query
    @result = HTTParty.get(ms_ip("in")+"/"+@username+"/inbox?"+query.to_query)
    render json: @result.body
  end

  #GET by id
  def received_mail
    @result = HTTParty.get(ms_ip("in")+"/"+@username+"/inbox/"+params[:id].to_s)
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Mail not found"}}.to_json
    end
  end

  #DELETE
  def delReceivedMail
    @result = HTTParty.delete(ms_ip("in")+"/"+@username+"/inbox/"+params[:id].to_s)
    if @result.code == 204
      render status: 204, json: {body:{message: "Mail deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Mail couldn't be deleted"}}.to_json
    end
  end

  def update_read
    data={
      read: params[:read]
    }
    @result = HTTParty.put(ms_ip("in")+"/"+@username+"/inbox/"+params[:id].to_s,body:data.to_json,headers: { "Content-Type": 'application/json'})
    if @result.code == 200
      render status: 200, json: {body:{message: "Mail updated"}}.to_json
    else
      render status: 404, json: {body:{message: "Mail couldn't be updated"}}.to_json
    end
  end
end
