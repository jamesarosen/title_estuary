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
