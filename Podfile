# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def app
  pod 'Masonry', '>=1.1.0'
  pod 'AFNetworking'
  pod 'IQKeyboardManager'
  pod 'GoogleMLKit/Translate'
  pod 'GoogleMLKit/LanguageID'
  pod 'GoogleMLKit/TextRecognition'
  pod 'GoogleMLKit/TextRecognitionChinese'
  pod 'GoogleMLKit/TextRecognitionDevanagari'
  pod 'GoogleMLKit/TextRecognitionJapanese'
  pod 'GoogleMLKit/TextRecognitionKorean'
end

def common
   pod 'CocoaAsyncSocket'
   pod "CocoaLumberjack"
   pod 'ShadowSocks-libev-iOS', :git => 'git@github.com:juvham/ShadowSocks-libev-iOS.git', :tag => 'master'
   pod 'PacketProcessor_iOS'
end

target 'Translate plus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  app
  common

  # Pods for Translate plus

end

target 'Translate-plus VPN' do
  use_frameworks!
  common
  pod 'ReachabilitySwift'
end
