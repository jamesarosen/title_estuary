require File.dirname(__FILE__) + '/test_helper'

class Pickle
  attr_reader :name
  def initialize(name); @name = name; end
  def to_s; name; end
end

class PicklesController < ApplicationController
  include TitleEstuary
  
  def index; render :nothing => true; end
  def new; index; end
  def create; new; end
  def burninated; index; end
  def show; @pickle = Pickle.find(params[:id]); render :nothing => true; end
  def edit; show; end
  def update; edit; end
  def burninate; show; end
  
end

class SimpleCustomTitlesTest < ActionController::TestCase
  tests PicklesController
  
  def self.should_set_the_page_title_to(title)
    should "set the page title to #{title}" do
      assert_equal title, @controller.page_title
    end
  end
  
  def self.should_ask_for_a_translation_of(key)
    should "ask for a translation of :#{key}" do
      @controller.page_title
      assert_received ::I18n, :t do |expect|
        expect.with do |*args|
          args.first == key.to_sym
        end
      end
    end
  end
  
  context 'a controller with TitleEstuary installed and with custom page titles set up' do
    
    setup do
      ActionController::Routing::Routes.draw do |map|
        map.resources :pickles
      end
    end
    
    context 'on a GET to :index' do
      setup do
        ::I18n.stubs(:t).returns "Some Pickles!"
        get :index
      end
      should_set_the_page_title_to 'Some Pickles!'
      should_ask_for_a_translation_of 'page.title.pickles.index'
    end
    
  end
  
end
