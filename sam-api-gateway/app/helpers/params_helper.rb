module ParamsHelper
  def self.inbox_params(params, username)
    inbox = {
      body: {
        :sender => username,
        :recipient => params[:recipient],
        :cc => params[:cc],
        :distribution_list => params[:distribution_list],
        :subject => params[:subject],
        :message_body => params[:message_body],
        :attachments => params[:attachment],
        :sent_date => params[:sent_date],
        :urgent => params[:urgent],
        :read => false
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
    }
    return inbox
  end

  def self.send_mail_params(params, username)
    mail = {
      body: {
        :sender => username,
        :recipient => params[:recipient],
        :distribution_list => params[:distribution_list],
        :subject => params[:subject],
        :message_body => params[:message_body],
        :attachment => params[:attachment],
        :cc => params[:cc],
        :sent_date => params[:sent_date],
        :draft => params[:draft],
        :urgent => params[:urgent],
        :confirmation => params[:confirmation]
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
    }
    return mail
  end
end
