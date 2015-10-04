FONT_AWESOME = YAML.load_file(Rails.root.to_s + ('/vendor/icons.yml'))
FONT_AWESOME_ICONS = FONT_AWESOME['icons'].map{|i| i['id']}.sort
