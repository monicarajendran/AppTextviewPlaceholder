
Pod::Spec.new do |s|
  s.name             = 'AppTextviewPlaceholder'
  s.version          = '0.1.0'
  s.summary          = 'A candy for Textview Placeholder, TL;DR Plug it, Get It, Use It.'
  s.homepage         = 'https://github.com/monicarajendran/AppTextviewPlaceholder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'monicarajendran' => 'monicarajendran96@gmail.com' }
  s.source           = { :git => 'https://github.com/monicarajendran/AppTextviewPlaceholder.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/monicarajendran'

  s.ios.deployment_target = '10.0'
  s.source_files = 'AppTextviewPlaceholder/Classes/**/*.{swift}'
  s.frameworks = 'UIKit', 'MapKit'
  
end
