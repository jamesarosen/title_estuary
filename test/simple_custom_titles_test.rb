require File.dirname(__FILE__) + '/test_helper'

class SimpleCustomTitlesTest < ActionController::TestCase
  include PageTitleMacros
  extend DeclareRestfulTitleizedController
  
  a_restful_titleized_controller('pickles_controller') do
    
    context 'with custom page titles set up' do

      setup { clear_translations! }
    
      context 'on a GET to :index' do
        setup do
          define_translation 'page.title.pickles.index', 'Some Pickles!'
          get :index
        end
        should_set_the_page_title_to 'Some Pickles!'
      end
      
      context 'on a GET to :new' do
        setup do
          define_translation 'page.title.pickles.new', 'Add a Pickle to the Jar'
          get :new
        end
        should_set_the_page_title_to "Add a Pickle to the Jar"
      end
      
    end
    
  end
  
end
