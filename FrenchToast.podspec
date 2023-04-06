Pod::Spec.new do |s|
  s.name             = 'FrenchToast'
  s.version          = '1.0.1'
  s.summary          = 'A Swift framework for the toastiest popups.'

  s.homepage         = 'https://github.com/oakstudios/FrenchToast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Givens' => 'alex@oak.is' }
  s.source           = { :git => 'https://github.com/oakstudios/FrenchToast.git', :tag => s.version.to_s }
  s.social_media_url = 'https://oak.social/@oak'

  s.ios.deployment_target = '13.0'
  s.source_files = 'FrenchToast/**/*'
  s.swift_version = '5.0'
end
