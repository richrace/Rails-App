class Image < ActiveRecord::Base
  # Sets the foreign key end of the one-to-one relationship
  belongs_to :user

  # This method is defined by the paperclip gem. We can 
  # access an attached file via the photo method (generated
  # by has_attached_file. We can add any number of styles and
  # then refer to them in: e.g. image.photo.url(:small) to
  # get say the file URL for the uploaded image. 
  # See users_helper.rb for examples. 
  # See https://github.com/thoughtbot/paperclip for details
  has_attached_file :photo,
	  :styles => {
	  	  :large=>"96x96#",
	  	  :medium=>"64x64#",
	  	  :small=>"48x48#",
	  	  :tiny=>"30x30#"
	  }
end

