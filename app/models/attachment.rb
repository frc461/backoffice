class Attachment < ActiveRecord::Base
    belongs_to :meeting
    #has_attached_file :file
    #validates_attachment :file, :content_type => {content_type: ["image/jpeg", "image/gif", "image/png", 'application/pdf']}
end
