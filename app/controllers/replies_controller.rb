class RepliesController < ApplicationController
  around_filter :ensure_user_can_view
  around_filter :ensure_logged_in, :only => [:create]
  around_filter :ensure_user_can_manage, :only => [:update, :destroy]
  
  before_filter :load_discussion
  
  
  def create
    if !current_user.can_engage?(@community)
      @community.memberships.create(:user_id => current_user.id, :access => -1, :approved => true)
    end
    
    @reply = Reply.new(params[:reply])
    @reply.discussion_id = @discussion.id
    @reply.user_id = current_user.id
    @reply.save
    
    redirect_to @discussion
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
  
  private
  
  def load_discussion
    @discussion = Discussion.with_id(params[:discussion_id]).first
  end
end
