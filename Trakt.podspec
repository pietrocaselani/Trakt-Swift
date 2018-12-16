#
# Be sure to run `pod lib lint Trakt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Trakt'
  s.version          = '0.1.0'
  s.summary          = 'A Swift wrapper around the Trakt v2 API using Moya.'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "A Swift library for Trakt v2 API using Moya and facilitating OAuth"

  s.homepage         = 'https://github.com/pietrocaselani/Trakt-Swift'
  s.license          = { :type => 'UNLICENSE', :file => 'UNLICENSE' }
  s.author           = { 'Pietro Caselani' => 'pc1992@gmail.com' }
  s.source           = { :git => 'https://github.com/pietrocaselani/Trakt-Swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pietropc_'
  s.module_name      = 'TraktSwift'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Trakt/**/*'

  s.dependency 'Moya/RxSwift', '12.0.1'
  s.dependency 'SwiftLint', '0.25.1'
end
