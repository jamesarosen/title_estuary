require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/village_model_and_controller'
require 'action_view/test_case'

class RailsIntegrationTest < ActionController::TestCase
  
  include PageTitleMacros
  tests VillagesController
  
  context 'a RESTful, titleized controller' do
    
    should "not have a :page_title action" do
      assert !VillagesController.action_methods.map { |a| a.to_sym }.include?(:page_title)
    end
    
    should 'expose :page_title to views as a helper' do
      helper = Object.new
      helper.extend VillagesController.master_helper_module
      assert helper.respond_to?(:page_title)
    end
    
  end
  
end
