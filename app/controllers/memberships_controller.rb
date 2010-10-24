class MembershipsController < ApplicationController
  around_filter :ensure_user_can_view, :only => [:index]
  around_filter :ensure_logged_in, :except => [:index]
  around_filter :ensure_user_can_manage, :only => [:approve, :disapprove, :promote, :demote]
  around_filter :load_membership, :only => [:destroy, :approve, :disapprove, :promote, :demote]
  
  def index
    @memberships = @community.memberships.ordered.all
  end
  
  def show
    if (@membership = @community.memberships.with_id(params[:id]).first).nil? or current_user.id != @membership.user_id
      flash[:notice] = "We're having some difficulty finding that membership."
      redirect_to root_url(:host => BASE_DOMAIN)
    elsif can_view?
      redirect_to root_path
    end
  end
  
  def new
    @redirect_to = params[:redirect_to]
    
    @membership = Membership.new
    
    if current_user.member_of?(@community) and current_user.member_of?(@community).approved?
      flash[:notice] = "You're already a member of this community."
      redirect_to (@redirect_to.blank? ? root_path : @redirect_to)
    elsif current_user.member_of?(@community)
      flash[:notice] = "You're membership for this community has yet to be approved."
      redirect_to current_user.member_of?(@community)
    end
  end
  
  def create
    if !current_user.member_of?(@community)
      if @community.memberships.create(:user_id => current_user.id, :access => -1, :approved => !@community.private?)
        if !@community.private?
          Action.publish(:type => :new_membership, :community => @community, :user => current_user, :actionable => @community)
        end
        
        flash[:notice] = 'Welcome to the community.'
      end
    end
    
    redirect_to root_path
  end
  
  def destroy
    if !@membership.manager? and current_user.id == @membership.user_id
      if @membership.destroy
        flash[:notice] = "Sorry to see you go."
      end
    end
    
    redirect_to memberships_path
  end
  
  def approve
    @membership.update_attribute(:approved, true)
    Action.publish(:type => :new_membership, :community => @community, :user => @membership.user, :actionable => @community)
    
    redirect_to memberships_path
  end
  
  def disapprove
    @membership.destroy
    redirect_to memberships_path
  end
  
  def promote
    @membership.update_attribute(:access, 1)
    redirect_to memberships_path
  end
  
  def demote
    @membership.update_attribute(:access, -1)
    redirect_to memberships_path
  end
  
  private
  
  def load_membership
    if (@membership = @community.memberships.with_id(params[:id]).first).nil?
      flash[:notice] = "We're having some difficulty finding that membership."
      redirect_to root_path
    else
      yield
    end
  end
end
