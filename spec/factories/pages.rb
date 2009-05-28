Factory.define :invalid_page , :class => Page do |p|
end

Factory.define :valid_top_level_folder , :class => Page do |p|
  p.title "Global Nav"
  p.published true
end

Factory.define :valid_standard_page , :class => Page do |p|
  p.title "About Us"
  p.published true
  p.parent   {|a| a.association(:valid_top_level_folder) }
end

