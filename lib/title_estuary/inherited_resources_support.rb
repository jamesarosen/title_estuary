module TitleEstuary
  
  module InheritedResourcesSupport
    def page_title_from_controller_and_action
      action, controller = params[:action].to_s, params[:controller].to_s
      if params[:id]
        instance = instance_variable_get(:"@#{controller.singularize}") || params[:id]
      end
      case action
      when 'index'
        "All #{resource_name.pluralize}"
      when 'new', 'create'
        "New #{resource_name.singularize}"
      when 'show'
        "#{resource_name.singularize} #{instance}"
      when 'edit', 'update'
        "Edit #{resource_name.singularize} #{instance}"
      else
        if instance.present?
          "#{action} #{resource_name.singularize} #{instance}"
        else
          "#{action} #{resource_name.pluralize}"
        end
      end.titleize
    end
    
    private
    
    def resource_name
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
