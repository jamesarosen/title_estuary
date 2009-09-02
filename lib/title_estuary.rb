# @author James Rosen
module TitleEstuary
  
  # When TitleEstuary is included by a controller,
  # this hook prevents ActionPack from using
  # <tt>#page_title</tt> as an action and makes that
  # method available to helpers and views; it also
  # auto-includes TitleEstuary::InheritedResourcesSupport
  # if applicable.
  def self.included(base)
    base.send :include, TitleEstuary::InstanceMethods
    base.hide_action :page_title if base.respond_to?(:hide_action)
    base.helper_method :page_title if base.respond_to?(:helper_method)
    if Object.const_defined?(:InheritedResources) && base < ::InheritedResources::Base
      base.send :include, TitleEstuary::InheritedResourcesSupport
    end
  end
  
  module InstanceMethods
  
    # @return [String] the page title
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
    
    # @return [Symbol] the I18n key for the page title for
    #         this controller/action pair.
    def page_title_i18n_key
      "page.title.#{params[:controller]}.#{params[:action]}".to_sym
    end
    
    # @return [String] a reasonably sane default title for
    #                  this controller/action pair.
    def default_page_title_from_controller_and_action
      action = params[:action].to_s
      resource_name = page_title_singular_resource_name
      resource = page_title_resource
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
    
    # @return [#to_s] an instance variable representing the requested
    #                 resource if it's in an obvious location.
    def page_title_resource
      if params[:id]
        instance_variable_get(:"@#{page_title_singular_resource_name}") || params[:id]
      end
    end
    
    # @return [String] a guess for the name of the requested resource.
    def page_title_singular_resource_name
      params[:controller].singularize
    end
  
  end
  
end
