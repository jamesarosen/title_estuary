# @author James Rosen
module TitleEstuary
  
  def self.included(base)
    base.send :include, TitleEstuary::InstanceMethods
    base.hide_action :page_title if base.respond_to?(:hide_action)
    base.helper_method :page_title if base.respond_to?(:helper_method)
    if Object.const_defined?(:InheritedResources) && base < ::InheritedResources::Base
      base.send :include, TitleEstuary::InheritedResourcesSupport
    end
  end
  
  module InstanceMethods
  
    def page_title
      return @content_for_page_title if @content_for_page_title.present?
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
      action = params[:action].to_s
      resource_name = page_title_singular_resource_name
      if params[:id]
        instance = instance_variable_get(:"@#{resource_name}") || params[:id]
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
    
    def page_title_singular_resource_name
      params[:controller].singularize
    end
  
  end
  
end
