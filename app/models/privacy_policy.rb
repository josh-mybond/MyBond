class PrivacyPolicy < ApplicationRecord

    STATUS = {
      draft: 0,
      published: 1
    }

    after_create :copy_previous_record

    #
    # Callbacks
    #

    def copy_previous_record
      tc = PrivacyPolicy.last

      return if tc.nil?

      self.status = STATUS[:draft]
      self.summary = tc.summary
      self.full    = tc.full
    end

    #
    # Class
    #

    def self.latest
      PrivacyPolicy
        .where(status: STATUS[:published])
        .order(updated_at: :desc)
        .limit(1)
    end

    #
    # Housekeeping
    #

    def status_to_s
      case self.status
      when STATUS[:draft] then "Draft"
      when STATUS[:published] then "Published"
      end
    end
end
