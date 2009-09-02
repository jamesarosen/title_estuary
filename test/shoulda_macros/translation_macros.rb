module TranslationMacros
  
  def clear_translations!
    I18n.reload!
  end
  
  def define_translation(key, value)
    hash = key.to_s.split('.').reverse.inject(value) do |value, key_part|
      { key_part.to_sym => value }
    end
    I18n.backend.send :merge_translations, I18n.locale, hash
  end
  
end
