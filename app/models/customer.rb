
class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable and :omniauthable
    # :confirmable,

  # Validations
  # Note: validations replaced by_status
  # validates :first_name, :last_name, :date_of_birth, presence: true, length: { maximum: 56 }
  # validate :mobile_number_is_valid

  validate :by_status
  validate :acceptable_image

  has_many :contracts

  has_one_attached :drivers_license
  has_one_attached :selfie

  #
  # Validations
  #

  def by_status
    case
    when self.prospect?
      if !Truemail.valid?(self.email, with: :regex)
        errors.add(:email, "is not valid")
      end
    when self.customer?
      errors.add(:first_name,    "cannot be blank") if self.first_name.blank?
      errors.add(:last_name,     "cannot be blank") if self.last_name.blank?
      errors.add(:date_of_birth, "cannot be blank") if self.date_of_birth.blank?

      # Validate mobile number
      if !Phonelib.valid_for_country? self.mobile_number, self.iso_country_code
        errors.add(:iso_country_code, "invalid with Mobile Number")
        errors.add(:mobile_number,    "invalid with Country Code")
      end

    end
  end

  # def mobile_number_is_valid
  #
  #   if !Phonelib.valid_for_country? self.mobile_number, self.iso_country_code
  #     errors.add(:iso_country_code, "invalid with Mobile Number")
  #     errors.add(:mobile_number,    "invalid with Country Code")
  #   end
  #
  # end

  #
  # Constants
  #

  STATUS = {
    prospect: 0,
    customer: 1
  }

  RESIDENTIAL_STATUS = {
    citizen: 0,
    permanent_resident: 1,
    working_visa: 2,
    other: 3
  }

  def prospect?
    self.status == STATUS[:prospect]
  end

  def customer?
    self.status == STATUS[:customer]
  end

  def status_to_s
    STATUS.each do |key, value|
      if self.status == value
        return key.to_s.capitalize.gsub("_"," ")
      end
    end

    "Unknown"
  end

  def residential_status_to_s
    RESIDENTIAL_STATUS.each do |key, value|
      if self.residential_status == value
        return key.to_s.capitalize.gsub("_"," ")
      end
    end

    "Unknown"
  end


  #
  # Main
  #

  def acceptable_image
    return unless self.drivers_license.attached? and self.selfie.attached?

    # https://pragmaticstudio.com/tutorials/using-active-storage-in-rails

    acceptable_types = ["image/jpeg", "image/png", "application/pdf"]
    error            = "must be a JPEG, PNG or PDF"

    if self.drivers_license.attached?
      unless acceptable_types.include?(drivers_license.content_type)
        errors.add(:drivers_license, error)
      end
    end

    if self.selfie.attached?
      unless acceptable_types.include?(selfie.content_type)
        errors.add(:selfie, error)
      end
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
