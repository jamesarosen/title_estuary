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
        "All #{controller.pluralize.titleize}"
      when 'new'
        "New #{controller.singularize.titleize}"
      when 'show'
        "#{controller.singularize.titleize}: #{instance.titleize}"
      else
        nil
      end
    end
  
  end
  
end
