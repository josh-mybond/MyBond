
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

  validate :acceptable_image

  has_many :contracts

  has_one_attached :drivers_license
  has_one_attached :face_photo

  #
  # Validations
  #

  def mobile_number_is_valid

    if !Phonelib.valid_for_country? self.mobile_number, self.iso_country_code
      errors.add(:iso_country_code, "invalid with Mobile Number")
      errors.add(:mobile_number,    "invalid with Country Code")
    end

  end

  def acceptable_image
  return unless self.drivers_license.attached? and self.face_photo.attached?

  # https://pragmaticstudio.com/tutorials/using-active-storage-in-rails

  acceptable_types = ["image/jpeg", "image/png", "application/pdf"]
  error            = "must be a JPEG, PNG or PDF"

  if self.drivers_license.attached?
    unless acceptable_types.include?(drivers_license.content_type)
      errors.add(:drivers_license, error)
    end
  end

  if self.face_photo.attached?
    unless acceptable_types.include?(face_photo.content_type)
      errors.add(:face_photo, error)
    end
  end

end


  RESIDENTIAL_STATUS = {
    citizen: 0,
    permanent_resident: 1,
    working_visa: 2,
    other: 3
  }

  def residential_status_to_s
    case self.residential_status
    when RESIDENTIAL_STATUS[:citizen]            then "Citizen"
    when RESIDENTIAL_STATUS[:permanent_resident] then "Permanent Resident"
    when RESIDENTIAL_STATUS[:working_visa]       then "Working Visa"
    when RESIDENTIAL_STATUS[:other]              then "Other"
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
