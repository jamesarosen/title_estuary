require File.dirname(__FILE__) + '/test_helper'
require 'inherited_resources'
require 'inherited_resources/actions'
require 'inherited_resources/base_helpers'
require 'inherited_resources/class_methods'
require 'inherited_resources/url_helpers'
require 'inherited_resources/base'

class Person
  def initialize(name)
    @name = name
  end
  def to_s
    @name.to_s
  end
end

class AccountsController < InheritedResources::Base
  self.resource_class = Person
  include TitleEstuary
  def index; render :nothing => true; end
  def confirmed; index; end
  def new; index; end
  def create; index; end
  def show; @account = Person.find(params[:id]); render :nothing => true; end
  def edit; show; end
  def update; show; end
  def confirm; show; end
end

class InheritedResourcesIntegrationTest < ActionController::TestCase
  include PageTitleMacros
  extend DeclareRestfulTitleizedController
  tests AccountsController
  
  def declare_route_resources(resources, options = {})
    ActionController::Routing::Routes.draw do |map|
      map.resources resources, options
    end
  end
  
  context 'a RESTful controller using both Title Estuary and Inherited Resources' do
    
    setup do
      declare_route_resources :accounts, :collection => { :confirmed => :get },
                                         :member     => { :confirm => :get }
    end
    
    context 'with custom page titles that involve interpolation' do
      
      setup do
        clear_translations!
      end
      
      should 'have inherited-resources support installed' do
        assert AccountsController < TitleEstuary::InheritedResourcesSupport
      end
      
      context 'on a GET to :index' do
        setup { get :index }
        should_set_the_page_title_to 'All People'
      end
      
      context 'on a GET to :new' do
        setup { get :new }
        should_set_the_page_title_to 'New Person'
      end
    
      context 'on a POST to :create that fails' do
        setup { post :create }
        should_set_the_page_title_to 'New Person'
      end
    
      context 'on a GET to :show for a resource that exists' do
        setup do
          Person.stubs(:find).returns(Person.new('Carl'))
          get :show, :id => 'anything'
        end
        should_set_the_page_title_to "Person Carl"
      end
    
      context 'on a GET to :show for a resource that does not exist (or is not set to an obvious instance variable)' do
        setup do
          Person.stubs(:find).returns(nil)
          get :show, :id => '2'
        end
        should_set_the_page_title_to "Person 2"
      end
    
      context 'on a GET to :edit for a resource that exists' do
        setup do
          Person.stubs(:find).returns(Person.new('Wendy'))
          get :edit, :id => 'something'
        end
        should_set_the_page_title_to "Edit Person Wendy"
      end
    
      context 'on a GET to :edit for a resource that does not exist (or is not set to an obvious instance variable)' do
        setup do
          Person.stubs(:find).returns(nil)
          get :edit, :id => '3'
        end
        should_set_the_page_title_to "Edit Person 3"
      end
    
      context 'on a PUT to :update for a resource that exists' do
        setup do
          Person.stubs(:find).returns(Person.new('Dwayne'))
          put :update, :id => 'seven'
        end
        should_set_the_page_title_to "Edit Person Dwayne"
      end
    
      context 'on a PUT to :update for a resource that does not exist (or is not set to an obvious instance variable)' do
        setup do
          Person.stubs(:find).returns(nil)
          put :update, :id => '100'
        end
        should_set_the_page_title_to "Edit Person 100"
      end
    
      context 'on a GET to a custom collection action' do
        setup { get :confirmed }
        should_set_the_page_title_to "Confirmed People"
      end
    
      context 'on a GET on a custom member action for a resource that exists' do
        setup do
          Person.stubs(:find).returns(Person.new('Regina'))
          get :confirm, :id => '14'
        end
        should_set_the_page_title_to "Confirm Person Regina"
      end
    
      context 'on a GET to a custom member action for a resource that does not exist (or is not set to an obvious instance variable)' do
        setup do
          Person.stubs(:find).returns(nil)
          get :confirm, :id => '9'
        end
        should_set_the_page_title_to "Confirm Person 9"
      end
      
    end
    
  end
  
end
