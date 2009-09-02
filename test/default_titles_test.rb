require File.dirname(__FILE__) + '/test_helper'

class Village
  attr_reader :name
  def initialize(name); @name = name; end
  def to_s; name; end
end

class VillagesController < ApplicationController
  include TitleEstuary
  
  def index; render :nothing => true; end
  def new; render :nothing => true; end
  def create; new; end
  def burninated; index; end
  def show; @village = Village.find(params[:id]); render :nothing => true; end
  def edit; show; end
  def update; edit; end
  def burninate; show; end
  
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
        map.resources :villages, :collection => { :burninated => :get },
                                 :member     => { :burninate  => :get }
      end
    end
    
    should "not have a :page_title action" do
      assert !VillagesController.action_methods.map { |a| a.to_sym }.include?(:page_title)
    end
    
    context 'on a GET to :index' do
      setup { get :index }
      should_set_the_page_title_to 'All Villages'
    end
    
    context 'on a GET to :new' do
      setup { get :new }
      should_set_the_page_title_to 'New Village'
    end
    
    context 'on a POST to :create that fails' do
      setup { post :create }
      should_set_the_page_title_to 'New Village'
    end
    
    context 'on a GET to :show for a resource that exists' do
      setup do
        Village.stubs(:find).returns(Village.new('Bostonburgh'))
        get :show, :id => 'anything'
      end
      should_set_the_page_title_to "Village Bostonburgh"
    end
    
    context 'on a GET to :show for a resource that does not exist (or is not set to an obvious instance variable)' do
      setup do
        Village.stubs(:find).returns(nil)
        get :show, :id => '2'
      end
      should_set_the_page_title_to "Village 2"
    end
    
    context 'on a GET to :edit for a resource that exists' do
      setup do
        Village.stubs(:find).returns(Village.new('Gloucestershire'))
        get :edit, :id => 'something'
      end
      should_set_the_page_title_to "Edit Village Gloucestershire"
    end
    
    context 'on a GET to :edit for a resource that does not exist (or is not set to an obvious instance variable)' do
      setup do
        Village.stubs(:find).returns(nil)
        get :edit, :id => '3'
      end
      should_set_the_page_title_to "Edit Village 3"
    end
    
    context 'on a PUT to :update for a resource that exists' do
      setup do
        Village.stubs(:find).returns(Village.new('East Umbridge'))
        put :update, :id => 'seven'
      end
      should_set_the_page_title_to "Edit Village East Umbridge"
    end
    
    context 'on a PUT to :update for a resource that does not exist (or is not set to an obvious instance variable)' do
      setup do
        Village.stubs(:find).returns(nil)
        put :update, :id => '100'
      end
      should_set_the_page_title_to "Edit Village 100"
    end
    
    context 'on a GET to a custom collection action' do
      setup { get :burninated }
      should_set_the_page_title_to "Burninated Villages"
    end
    
    context 'on a GET on a custom member action for a resource that exists' do
      setup do
        Village.stubs(:find).returns(Village.new('Parrotshire'))
        get :burninate, :id => '14'
      end
      should_set_the_page_title_to "Burninate Village Parrotshire"
    end
    
    context 'on a GET to a custom member action for a resource that does not exist (or is not set to an obvious instance variable)' do
      setup do
        Village.stubs(:find).returns(nil)
        get :burninate, :id => '9'
      end
      should_set_the_page_title_to "Burninate Village 9"
    end
    
  end
  
end
