class PagesController < ApplicationController
  around_filter :ensure_user_can_view
  around_filter :ensure_user_can_manage, :except => [:index, :show, :history]
  
  def index
    redirect_to root_path
  end
  
  def show
    if (@page = @community.pages.with_slug(params[:id]).first).nil?
      flash[:notice] = "The page you're looking for doesn't exist."
      redirect_to root_path
    else
      @page_revision = @page.page_revisions.with_id(params[:revision_id]).first
    end
  end
  
  def history
    if (@page = @community.pages.with_slug(params[:id]).first).nil?
      flash[:notice] = "The page you're looking for doesn't exist."
      redirect_to root_path
    else
      @page_revisions = @page.page_revisions.ordered.all
    end
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    @page.community_id = @community.id
    @page.user_id = current_user.id
    
    if @page.save
      flash[:notice] = 'That page has been successfully created.'
      redirect_to @page
    else
      render :action => 'new'
    end
  end
  
  def edit
    if (@page = @community.pages.with_slug(params[:id]).first).nil?
      flash[:notice] = "The page you're looking for doesn't exist."
      redirect_to root_path
    end
  end
  
  def update
    if @page = @community.pages.with_slug(params[:id]).first
      params[:page][:user_id] = current_user.id
      params[:page][:name] = 'Overview' if params[:id] == 'overview'
      params[:page].delete(:slug)
      
      if @page.update_attributes(params[:page])
        flash[:notice] = 'That page has been successfully updated.'
        redirect_to (@page.overview? ? root_path : @page)
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = "The page you're looking for doesn't exist."
      redirect_to root_path
    end
  end
  
  def destroy
    if (@page = @community.pages.with_slug(params[:id]).first)
      if @page.destroy
        flash[:notice] = 'That page was successfully deleted.'
      end
    end
    
    redirect_to root_path
  end
end
