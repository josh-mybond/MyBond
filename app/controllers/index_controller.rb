class IndexController < ApplicationController

  def index
  end

  def app
  end

  def privacy_policy
    @content = PrivacyPolicy::latest
  end

  def terms_and_conditions
    @content = TermsAndCondition::latest
  end

  def contact
  end

end
