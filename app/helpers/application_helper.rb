module ApplicationHelper

  def flash_class(level)
    case level
      when :notice  then "alert alert-info"
      when :success then "alert alert-success"
      when :error   then "alert alert-danger"
      when :alert   then "alert alert-warning"
    end
  end

  def celebrate
    "🎂"
  end

  def good
    "✅"
  end

  def bad
    "🍄"
  end

  def really_bad
    "💣"
  end

  def invalid_html_message
    "All your base are belong to us"
  end

  def currency(number)
    # sprintf('$%.2f', number.to_f / 100)
    sprintf('$%.2f', number.to_f)
  end

  def format_date(date)
    return date if date.is_a? String
    date.in_time_zone("Australia/Sydney").strftime("%A, %d %b %Y %H:%M %p")
  end


end
