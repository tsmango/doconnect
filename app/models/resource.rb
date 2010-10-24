class Resource < ActiveRecord::Base
  acts_as_list :scope => :community
  
  scoped_search :on => [:path, :description]
  scoped_search :on => [:name, :description], :in => :parameters
  
  belongs_to :community
  belongs_to :user
  
  has_many :parameters, :dependent => :destroy
  accepts_nested_attributes_for :parameters, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }, :allow_destroy => true
  
  has_many :responses, :dependent => :destroy
  accepts_nested_attributes_for :responses, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }, :allow_destroy => true
  
  named_scope :with_slug, lambda {|slug| {:conditions => {:slug => slug}}}
  
  validates_presence_of :community_id
  validates_presence_of :user_id
  validates_presence_of :path
  validates_presence_of :url
  validates_presence_of :slug
  validates_presence_of :supported_formats
  validates_presence_of :supported_methods
  
  validates_uniqueness_of :slug, :scope => :community_id
  
  validates_format_of :url, :with => URI.regexp
  
  validates_inclusion_of :supported_methods, :in => %w( GET POST PUT DELETE )
  
  before_validation :generate_slug, :strip_leading_slash_from_path
  after_save :publish_action
  
  def generate_slug
    self.slug = "#{self.supported_methods.downcase}-#{Util::Slug.generate(self.path)}" if (!self.path.blank? and !self.supported_methods.blank?)
  end
  
  def publish_action
    Action.publish(:type => :updated_resource, :community => self.community, :user => self.user, :actionable => self)
  end
  
  def strip_leading_slash_from_path
    if self.path[/^\//]
      self.path.gsub(/^\//, '')
    elsif self.path[/^http:\/\//]
      self.path.gsub(/^http:\/\//, '')
    end
  end
  
  def description_as_html
    RDiscount.new(self.description.nil? ? '' : self.description, :filter_html, :filter_styles, :autolink).to_html
  end
  
  def to_param
    self.slug
  end
end
