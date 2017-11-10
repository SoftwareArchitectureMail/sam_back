class ApplicationRecord < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	self.abstract_class = true
end
