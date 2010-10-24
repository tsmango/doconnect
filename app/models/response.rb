class Response < ActiveRecord::Base
  acts_as_list :scope => :resource
  
  belongs_to :resource
  belongs_to :user
  
  named_scope :with_id, lambda {|id| {:conditions => {:id => id}}}
end
