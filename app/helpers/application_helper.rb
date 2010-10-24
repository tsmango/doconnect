module ApplicationHelper
  def logged_in?
    current_user ? true : false
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def can_view?
    @community.open? or (logged_in? and current_user.can_view?(@community))
  end
  
  def can_engage?
    logged_in? and current_user.can_engage?(@community)
  end
  
  def can_manage?
    logged_in? and current_user.can_manage?(@community)
  end
  
  def show_privacy_explanation_for(community)
    case community.privacy
    when 0
      return "$j('#closed').show();"
    when -1
      return "$j('#private').show();"
    else
      return "$j('#open').show();"
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def render_action_item(action_item)
    html = action_item.action_type.template
    
    html = html.gsub(/\{community\}/,   link_to(action_item.actionable.name, action_item.actionable.url))  if action_item.actionable_type == 'Community'
    html = html.gsub(/\{page\}/,        link_to(action_item.actionable.name, page_url(action_item.actionable, :host => action_item.community.host)))  if action_item.actionable_type == 'Page'
    html = html.gsub(/\{resource\}/,    link_to(action_item.actionable.path, resource_url(action_item.actionable, :host => action_item.community.host)))  if action_item.actionable_type == 'Resource'
    html = html.gsub(/\{discussion\}/,  link_to(action_item.actionable.title, discussion_url(action_item.actionable, :host => action_item.community.host))) if action_item.actionable_type == 'Discussion'
    
    return html
  end
end
