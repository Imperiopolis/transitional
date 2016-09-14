Pod::Spec.new do |s|
  s.name             = "Transitional"
  s.version          = "0.1.0"
  s.summary          = "Quick and easy custom transitions."
  s.homepage         = "https://github.com/imperiopolis/Transitional"
  s.license          = 'MIT'
  s.author           = { "Imperiopolis" => "me@trappdesign.net" }
  s.source           = { :git => "https://github.com/imperiopolis/Transitional.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/imperiopolis'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Transitional/*.swift'
end
