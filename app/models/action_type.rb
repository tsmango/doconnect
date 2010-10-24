class ActionType < ActiveRecord::Base
  named_scope :with_name, lambda {|name| {:conditions => {:name => name}}}
  
  def self.kind_of(name)
    ActionType.with_name(name.to_s).first
  end
end
