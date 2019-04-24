#
# Be sure to run `pod lib lint CodableNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CodableNetworking'
  s.version          = '0.1.0'
  s.summary          = 'Simple networking abstraction layer'

  s.description      = <<-DESC
  This pod is a derivative of delightful CodableStore library. It drops support for UserDefaults and focuses only on networking. It enables URLSession configuration if needed.
  DESC

  s.homepage         = 'https://github.com/jakubpetrik/CodableNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jakub Petrík' => 'https://github.com/jakubpetrik' }
  s.source           = { :git => 'https://github.com/jakubpetrik/CodableNetworking.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/odpadnem'

  s.ios.deployment_target = '11.4'
  s.swift_version = '5.0'
  s.source_files = 'CodableNetworking/Classes/**/*'
  s.dependency 'PromiseKit', '~> 6.8'
end
