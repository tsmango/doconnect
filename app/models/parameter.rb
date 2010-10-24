class Parameter < ActiveRecord::Base
  acts_as_list :scope => :resource
  
  belongs_to :resource
  belongs_to :user
end
