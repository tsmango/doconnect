class CommunitiesController < ApplicationController
  around_filter :ensure_logged_in, :except => [:activity, :search]
  around_filter :ensure_user_can_view, :only => [:activity]
  
  def new
    @community = Community.new
  end
  
  def create
    @community = Community.new(params[:community])
    @community.user_id = current_user.id
    
    if @community.save
      flash[:notice] = 'Your community has been successfully created.'
      redirect_to @community.url
    else
      render :action => 'new'
    end
  end
  
  def process_name
    name = params[:name]
    
    if !(name_normalized = Util::Slug.trim(name.gsub(/[^a-z0-9]+/i, ''))).nil?
      @subdomain = name_normalized.downcase
    end
  end
  
  def activity
    @actions = Action.in_communities(@community.id).ordered.all(:limit => 25)
  end
  
  def search
    if params[:q].blank?
      redirect_to root_path
    else
      if defined?(@community)
        if can_view?
          @pages       = @community.pages.search_for(params[:q]).all(:first, 5)
          @discussions = @community.discussions.search_for(params[:q]).all(:first, 5)
          @resources   = @community.resources.search_for(params[:q]).all(:first, 5)
        else
          flash[:notice] = 'You must be logged in to do that.'
          redirect_to login_path
        end
      elsif logged_in?
        @communities = Community.search_for(params[:q]).all(:first, 15)
      else
        flash[:notice] = 'You must be logged in to do that.'
        redirect_to login_path
      end
    end
  end
end
