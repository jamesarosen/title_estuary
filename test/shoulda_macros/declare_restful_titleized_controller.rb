module DeclareRestfulTitleizedController
  
  def a_restful_titleized_controller(controller_name, routing_options = {}, &block)
    controller_name << 'Controller' unless controller_name =~ /controller$/i
    controller_name = controller_name.classify
    model_class_name = controller_name.sub(/Controller$/, '').singularize
    Object.send(:remove_const, controller_name) if Object.const_defined?(controller_name)
    Object.send(:remove_const, model_class_name) if Object.const_defined?(model_class_name)
    controller_class = Class.new(ApplicationController)
    controller_class.class_eval %|
      include TitleEstuary
      def index; render :nothing => true; end
      def new; index; end
      def create; index; end
      def show; @#{model_class_name.underscore} = #{model_class_name}.find(params[:id]); index; end
      def edit; show; end
      def update; show; end
      def destroy; show; end
    |
    routing_options.fetch(:collection, {}).keys.each do |action|
      controller_class.class_eval "def #{action}; index; end"
    end
    routing_options.fetch(:member, {}).keys.each do |action|
      controller_class.class_eval "def #{action}; show; end"
    end
    Object.const_set(controller_name, controller_class)
    self.tests controller_class
    
    model_class = Class.new do
      def initialize(to_s)
        @to_s = to_s
      end
      def to_s; @to_s; end
    end
    Object.const_set(model_class_name, model_class)
    
    ActionController::Routing::Routes.draw do |map|
      map.resources controller_name.underscore.sub(/_controller$/, '').pluralize, routing_options
    end
    
    context "A RESTful, controller with TitleEstuary installed" do
      block.call
    end
    
  end
  
end