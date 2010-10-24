class ResourcesController < ApplicationController
  around_filter :ensure_user_can_view
  around_filter :ensure_user_can_manage, :except => [:index, :show]
  
  def index
    redirect_to root_path
  end
  
  def show
    if (@resource = @community.resources.with_slug(params[:id]).first).nil?
      flash[:notice] = "The resource you're looking for doesn't exist."
      redirect_to root_path
    elsif @response = @resource.responses.with_id(params[:response_id]).first
      render :text => CodeRay.scan(@response.body, @response.format.to_sym).page
    end
  end
  
  def new
    @resource = Resource.new
    @resource.parameters.build
    @resource.responses.build
  end
  
  def create
    @resource = Resource.new(params[:resource])
    @resource.community_id = @community.id
    @resource.user_id = current_user.id
    
    if @resource.save
      flash[:notice] = 'That resource has been successfully created.'
      redirect_to @resource
    else
      render :action => 'new'
    end
  end
  
  def edit
    if (@resource = @community.resources.with_slug(params[:id]).first).nil?
      flash[:notice] = "The resource you're looking for doesn't exist."
      redirect_to root_path
    end
  end
  
  def update
    if @resource = @community.resources.with_slug(params[:id]).first
      params[:resource][:user_id] = current_user.id
      
      if @resource.update_attributes(params[:resource])
        flash[:notice] = 'That resource has been successfully updated.'
        redirect_to @resource
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = "The resource you're looking for doesn't exist."
      redirect_to root_path
    end
  end
  
  def destroy
    if (@resource = @community.resources.with_slug(params[:id]).first)
      if @resource.destroy
        flash[:notice] = 'That resource was successfully deleted.'
      end
    end
    
    redirect_to root_path
  end
end
