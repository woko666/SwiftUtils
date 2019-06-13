
Pod::Spec.new do |s|
  s.name             = 'SwiftUtilsGithub'
  s.version          = '0.0.5'
  s.summary          = 'A collection of convenience utils and extensions that should have been in vanilla swift '

  s.license          = 'MIT'
  s.homepage         = "https://github.com/woko666/SwiftUtils"
  s.author           = { 'Woko' => 'woko@centrum.cz' }
  s.source           = { :git => "https://github.com/woko666/SwiftUtils.git", :tag => s.version }
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.source_files  = ["Sources/**/*.swift"]
  s.library = 'iconv'
end

# pod lib lint
# pod trunk push SwiftUtilsGithub.podspec
