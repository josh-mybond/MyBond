
class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable and :omniauthable
    # :confirmable,

  # Validations
  validates :first_name, :last_name, :date_of_birth, presence: true, length: { maximum: 56 }
  # validates :email, email: true, presence: true, reduce: true # This causes 'Email is Invalid' to be printed twice

  validate :mobile_number_is_valid

  has_many :contracts

  #
  # Validations
  #

  def mobile_number_is_valid

    if !Phonelib.valid_for_country? self.mobile_number, self.iso_country_code
      errors.add(:iso_country_code, "invalid with Mobile Number")
      errors.add(:mobile_number,    "invalid with Country Code")
    end

  end


  if !Rails.env.production?
    def self.test_email
      "#{Time.now.to_i}@test.com"
    end
  end

  #
  #
  #

  def full_name
    "#{self.first_name} #{self.last_name}"
  end


  #
  # Phone number
  #

  def local_mobile
    self.mobile_number
  end

  def country_code
    Country[self.iso_country_code].country_code
  end

  def international_mobile
    Phony.normalize("#{self.country_code}#{self.mobile_number}")
  end


end
