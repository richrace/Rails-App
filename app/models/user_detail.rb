require 'digest/sha2'
class UserDetail < ActiveRecord::Base
  validates_presence_of 	  :login
  validates_presence_of     :level
  validates_uniqueness_of   :login, :within => 3..40
  validates_uniqueness_of   :login
  validates_confirmation_of :password
  validates_presence_of     :password_confirmation

  belongs_to :user
  
  ADMIN_LEVEL = 0
  CONTRIBUTOR_LEVEL = 1
  REGISTER_LEVEL = 2
  EDITOR_LEVEL = 3
  NORMAL_LEVEL = 5

  def password=(pass)
    return if pass.blank?
    create_new_salt
    self.crypted_password = UserDetail.encrypt_password(pass, self.salt)
  end
  
  def password
    return self.crypted_password
  end

  def password_confirmation=(pass)
    return if pass.blank?
    @con_pass = UserDetail.encrypt_password(pass, self.salt)
  end
  
  def password_confirmation 
    return @con_pass
  end
  
  def self.authenticate(name, password)
    user_detail = self.find_by_login(name)
    if user_detail
      expected_password = encrypt_password(password, user_detail.salt)
      if user_detail.crypted_password != expected_password
        user_detail = nil
      end
    end
    user_detail
  end
  
  def UserDetail.encrypt_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA256.hexdigest(string_to_hash)
  end

  private

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  
end
