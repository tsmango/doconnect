class ApplicationController < ActionController::Base
  before_filter :ensure_proper_domain, :load_community
  
  filter_parameter_logging :password
  helper :all
  protect_from_forgery
  
  protected
  
  def logged_in?
    current_user ? true : false
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def can_view?
    @community.open? or (logged_in? and current_user.can_view?(@community))
  end
  
  def can_engage?
    logged_in? and current_user.can_engage?(@community)
  end
  
  def can_manage?
    logged_in? and current_user.can_manage?(@community)
  end
  
  def ensure_logged_in
    if logged_in?
      yield
    else
      flash[:notice] = "You must be logged in to do that."
      redirect_to login_path
    end
  end
  
  def ensure_user_can_view
    if can_view?
      yield
    else
      redirect_to new_membership_path
    end
  end
  
  def ensure_user_can_engage
    if can_engage?
      yield
    else
      flash[:notice] = "You aren't allowed to engage with this community."
      return_or_redirect_to(root_path)
    end
  end
  
  def ensure_user_can_manage
    if can_manage?
      yield
    else
      flash[:notice] = "You aren't allowed to do that."
      return_or_redirect_to(root_path)
    end
  end
  
  def ensure_proper_domain
    if Rails.env.production? and (request.host == 'doconnect.r10.railsrumble.com')
      redirect_to 'http://doconnect.me'
    end
  end
  
  def load_community
    if request.host != BASE_DOMAIN
      if !(@community = Community.find_by_url(request.host, request.subdomains.first))
        flash[:notice] = "Sorry, we couldn't find a community at that address."
        redirect_to root_url(:host => BASE_DOMAIN)
      end
    end
  end
  
  def return_or_redirect_to(path)
    redirect_to (!request.env['HTTP_REFERER'].blank? ? request.env['HTTP_REFERER'] : path)
  end
end
