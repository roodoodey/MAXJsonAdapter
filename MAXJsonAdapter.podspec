#
# Be sure to run `pod lib lint MAXJsonAdapter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MAXJsonAdapter'
  s.version          = '0.1.7'
  s.summary          = 'MAXJsonAdapter is a powerful object serialization and deserialization framework for JSON.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC

MAXJsonAdapter is intended for developers who want a simple, yet powerful, serialization and deserialization framework for JSON which does not require subclassing such as Mantle.

Subclassing is a vital aspect of programming and most of the time we would like to have control over our root subclasses and not require third party subclasses which are out of our control. This project allows you to easily create model objects from json and vice versa.

                       DESC

  s.homepage         = 'https://github.com/roodoodey/MAXJsonAdapter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'roodoodey' => 'Mathieu Grettir Skúlason' }
  s.source           = { :git => 'https://github.com/roodoodey/MAXJsonAdapter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MAXJsonAdapter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MAXJsonAdapter' => ['MAXJsonAdapter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
