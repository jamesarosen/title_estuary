# @author James Rosen
module TitleEstuary
  
  def self.included(base)
    base.send :include, TitleEstuary::InstanceMethods
    base.hide_action :page_title if base.respond_to?(:hide_action)
  end
  
  module InstanceMethods
  
    def page_title
      page_title_from_controller_and_action
    end
    
    private
    
    def page_title_from_controller_and_action
      action, controller = params[:action].to_s, params[:controller].to_s
      if params[:id]
        instance = instance_variable_get(:"@#{controller.singularize}") || params[:id]
      end
      case action
      when 'index'
        "All #{controller.pluralize}"
      when 'new', 'create'
        "New #{controller.singularize}"
      when 'show'
        "#{controller.singularize} #{instance}"
      when 'edit'
        "Edit #{controller.singularize} #{instance}"
      else
        if instance.blank?
          "#{action} #{controller.pluralize}"
        else
          "#{action} #{controller.singularize} #{instance}"
        end
      end.titleize
    end
  
  end
  
end
