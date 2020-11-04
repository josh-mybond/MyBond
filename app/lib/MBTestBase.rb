class MBTestBase

  def initialize
    @errors = []

    ActiveRecord::Base.logger = nil # turn off active record logging
    ActionMailer::Base.perform_deliveries = false # Turn off emails
  end

  def errors?
    @errors.count != 0
  end

  def heading(string)
    puts "😀** #{string}"
  end

  def good(string)
    puts "  😀 #{string}".green
  end

  def bad(string)
    string = "  🍄 #{string}"
    puts string.red
    @errors << string
  end

  def die!(message)
    bad message
    exit 0
  end

  def test_response(test, result)
    puts case result
      when true  then good(test)
      when false then die!(test)
      end
  end

end
