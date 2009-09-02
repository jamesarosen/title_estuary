require File.dirname(__FILE__) + '/test_helper'

class InterpolatedPageTitlesTest < ActionController::TestCase
  include PageTitleMacros
  extend DeclareRestfulTitleizedController
  
  a_restful_titleized_controller('stuffed_animals_controller') do
    
    context 'with custom page titles that involve interpolation' do
      
      setup { clear_translations! }
        
      setup do
        self.class.controller_class.class_eval do
          def interpolation_options
            {
              :stuffed_animals_count => 12,
              :stuffed_animal_name   => 'Upton the Rhinoceros'
            }
          end
        end
      end
    
      context 'on a GET to :index' do
        setup do
          define_translation 'page.title.stuffed_animals.index', '{{stuffed_animals_count}} Stuffed Animals'
          get :index
        end
        should_set_the_page_title_to '12 Stuffed Animals'
      end
      
      context 'on a GET to :show' do
        setup do
          StuffedAnimal.stubs(:find).returns(StuffedAnimal.new('anything'))
          define_translation 'page.title.stuffed_animals.show', '{{stuffed_animal_name}}'
          get :show, :id => 29291
        end
        should_set_the_page_title_to 'Upton the Rhinoceros'
      end
      
      context 'that fails to provide a necessary interpolation string' do
        setup do
          define_translation 'page.title.stuffed_animals.new', '{{not_specified_by_the_controller}}'
          get :new
        end
        should "raise a translation error" do
          assert_raises I18n::MissingInterpolationArgument do
            @controller.page_title
          end
        end
      end
      
    end
    
  end
  
end
