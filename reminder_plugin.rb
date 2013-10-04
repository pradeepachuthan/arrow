class MessageAddlAttachment < ActiveRecord::Base
has_attached_file :attachment,
    :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
belongs_to :reminder


end
