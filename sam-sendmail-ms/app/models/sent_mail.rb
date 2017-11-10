class SentMail < ApplicationRecord
	mount_base64_uploader :attachment, AttachmentUploader

	validates :sender, :recipient, :subject, :message_body, presence: {message: "Campo obligatorio"}
	validates :sender, :recipient, length: { minimum: 5, too_short: "Este campo requiere al menos 5 caracteres" }
  validates :attachment, file_size: { less_than_or_equal_to: 20.megabytes  }

	def self.sent(params)
		unless params[:urgent]
			byUser(params[:sender]).order('sent_date DESC').where(draft: false).paginate(page: params[:page], per_page: params[:per_page])
		else
			byUser(params[:sender]).order('sent_date DESC').where(draft: false,urgent: params[:urgent]).paginate(page: params[:page], per_page: params[:per_page])
		end
	end

	def self.byUser(user)
		where(sender: user)
	end

	def self.drafts(params)
		unless params[:urgent]
			byUser(params[:sender]).order('created_at DESC').where(draft: true).paginate(page: params[:page], per_page: params[:per_page])
		else
			byUser(params[:sender]).order('created_at DESC').where(draft: true,urgent: params[:urgent]).paginate(page: params[:page], per_page: params[:per_page])
		end
	end

	def self.sentId(params)
		where(sender: params[:sender], draft: false).find(params[:id])
	end

	def self.draftsId(params)
		where(sender:params[:sender],draft: true).find(params[:id])
	end

end
