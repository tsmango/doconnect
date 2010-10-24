class DashboardController < ApplicationController
  
  def index
    if defined?(@community)
      redirect_to dashboard_url(:host => BASE_DOMAIN)
    elsif !logged_in?
      @rumble = true
      render :action => 'marketing'
    else
      @actions = Action.in_communities(current_user.communities.collect(&:id)).ordered.all(:limit => 25)
    end
  end
  
  def marketing
    if defined?(@community)
      redirect_to home_url(:host => BASE_DOMAIN)
    end
    
    @rumble = true
  end
end
