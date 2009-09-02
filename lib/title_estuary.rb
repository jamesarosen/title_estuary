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
      default = default_page_title_from_controller_and_action
      options = given_options.merge(:default => default)
      I18n.t page_title_i18n_key, options
    end
    
    private
    
    def page_title_i18n_key
      "page.title.#{params[:controller]}.#{params[:action]}".to_sym
    end
    
    def default_page_title_from_controller_and_action
      action = params[:action].to_s
      resource_name = page_title_singular_resource_name
      resource = page_title_instance
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
          "#{action.titleize} #{resource_name.singularize.titleize} #{resource}"
        else
          "#{action.titleize} #{resource_name.pluralize.titleize}"
        end
      end
    end
    
    def page_title_instance
      if params[:id]
        instance_variable_get(:"@#{page_title_singular_resource_name}") || params[:id]
      end
    end
    
    def page_title_singular_resource_name
      params[:controller].singularize
    end
  
  end
  
end
