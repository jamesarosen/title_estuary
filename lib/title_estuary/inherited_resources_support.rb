module TitleEstuary
  
  module InheritedResourcesSupport
    def page_title_from_controller_and_action
      action = params[:action].to_s
      resource_name = page_title_singular_resource_name
      case action
      when 'index'
        "All #{resource_name.pluralize.titleize}"
      when 'new', 'create'
        "New #{resource_name.singularize.titleize}"
      when 'show'
        "#{resource_name.singularize.titleize} #{resource}"
      when 'edit', 'update'
        "Edit #{resource_name.singularize.titleize} #{resource}"
      else
        if resource.present?
          "#{action.titleize} #{resource_name.titleize} #{resource}"
        else
          "#{action.titleize} #{resource_name.pluralize.titleize}"
        end
      end
    end
    
    private
    
    def page_title_singular_resource_name
      resource_name = if resource_class
        if resource_class.respond_to?(:human_name)
          resource_class.human_name
        else
          resource_class.name.humanize
        end
      else
        params[:controller].to_s.singularize
      end
    end
  end
  
end
