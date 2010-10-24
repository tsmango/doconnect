class DiscussionsController < ApplicationController
  around_filter :ensure_user_can_view
  around_filter :ensure_logged_in, :only => [:new, :create]
  around_filter :ensure_user_can_manage, :only => [:edit, :update, :destroy]
  
  def index
    @discussions = @community.discussions.ordered.all
  end
  
  def show
    if (@discussion = @community.discussions.with_id(params[:id]).first).nil?
      flash[:notice] = "The discussion you're looking for doesn't exist."
      redirect_to discussions_path
    else
      @reply = Reply.new
    end
  end
  
  def new
    @discussion = Discussion.new
  end
  
  def create
    if !current_user.can_engage?(@community)
      @community.memberships.create(:user_id => current_user.id, :access => -1, :approved => true)
    end
    
    @discussion = Discussion.new(params[:discussion])
    @discussion.community_id = @community.id
    @discussion.user_id = current_user.id
    
    if @discussion.save
      flash[:notice] = 'That discussion has been successfully started.'
      redirect_to @discussion
    else
      render :action => 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    if (@discussion = @community.discussions.with_id(params[:id]).first)
      if @discussion.destroy
        flash[:notice] = 'That discussion was successfully deleted.'
      end
    end
    
    redirect_to discussions_path
  end
end
