# @author James Rosen
module TitleEstuary
  
  def self.included(base)
    base.send :include, TitleEstuary::InstanceMethods
    base.hide_action :page_title if base.respond_to?(:hide_action)
    if Object.const_defined?(:InheritedResources) && base < ::InheritedResources::Base
      base.send :include, TitleEstuary::InheritedResourcesSupport
    end
  end
  
  module InstanceMethods
  
    def page_title
      given_options = if self.respond_to?(:interpolation_options)
        interpolation_options
      else
        {}
      end
      options = given_options.merge(:default => page_title_from_controller_and_action)
      I18n.t page_title_i18n_key, options
    end
    
    private
    
    def page_title_i18n_key
      "page.title.#{params[:controller]}.#{params[:action]}".to_sym
    end
    
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
      when 'edit', 'update'
        "Edit #{controller.singularize} #{instance}"
      else
        if instance.present?
          "#{action} #{controller.singularize} #{instance}"
        else
          "#{action} #{controller.pluralize}"
        end
      end.titleize
    end
  
  end
  
end
