require File.dirname(__FILE__) + '/test_helper'

class Village
end

class VillagesController < ApplicationController
  include TitleEstuary
  
  def index; render :nothing => true; end
  
end

class DefaultTitlesTest < ActionController::TestCase
  tests VillagesController
  
  def self.should_set_the_page_title_to(title)
    should "set the page title to #{title}" do
      assert_equal title, @controller.page_title
    end
  end
  
  context 'a controller with TitleEstuary installed but no custom page titles set up' do
    
    setup do
      ActionController::Routing::Routes.draw do |map|
        map.resources :villages
      end
    end
    
    should "not have a :page_title action" do
      assert !VillagesController.action_methods.map { |a| a.to_sym }.include?(:page_title)
    end
    
    context 'on a GET to :index' do
      
      setup do
        get :index
      end
      
      should_set_the_page_title_to 'All Villages'
      
    end
    
  end
  
end
