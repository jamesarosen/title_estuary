# @author James Rosen
module TitleEstuary
  
  def self.included(base)
    base.send :include, TitleEstuary::InstanceMethods
    base.hide_action :page_title if base.respond_to?(:hide_action)
  end
  
  module InstanceMethods
  
    def page_title
      'All Villages'
    end
  
  end
  
end
