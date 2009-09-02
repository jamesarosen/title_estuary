require File.dirname(__FILE__) + '/test_helper'

class SimpleCustomTitlesTest < ActionController::TestCase
  extend PageTitleMacros
  extend DeclareRestfulTitleizedController
  
  a_restful_titleized_controller('pickles_controller') do
    
    context 'with custom page titles set up' do
    
      context 'on a GET to :index' do
        setup do
          ::I18n.stubs(:t).returns "Some Pickles!"
          get :index
        end
        should_set_the_page_title_to 'Some Pickles!'
        should_ask_for_a_translation_of 'page.title.pickles.index'
      end
      
      context 'on a GET to :new' do
        setup do
          ::I18n.stubs(:t).returns "Add a Pickle to the Jar"
          get :new
        end
        should_set_the_page_title_to "Add a Pickle to the Jar"
        should_ask_for_a_translation_of 'page.title.pickles.new'
      end
      
    end
    
  end
  
end
