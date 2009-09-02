module PageTitleMacros
  
  def should_set_the_page_title_to(title)
    should "set the page title to #{title}" do
      assert_equal title, @controller.page_title
    end
  end
  
  def should_ask_for_a_translation_of(key)
    should "ask for a translation of :#{key}" do
      @controller.page_title
      assert_received ::I18n, :t do |expect|
        expect.with do |*args|
          args.first == key.to_sym
        end
      end
    end
  end
  
end
