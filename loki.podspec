#
# Be sure to run `pod lib lint Loki.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Loki"
  s.version          = "0.1.0"
  s.summary          = "A short description of Loki."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
This is a lib to rotate views according to language direction.
If you are using iOS < 9.0 for ar applications then you need this library to perform autofip for views, iamges, controllers.
If you support iOS 8 and greater then you need adjust the rules for built-in and custom flippings.
                       DESC

  s.homepage         = "https://github.com/mojidabckuu/Loki"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "mojidabckuu" => "mojidabckuu.22.06.92@gmail.com" }
  s.source           = { :git => "https://github.com/mojidabckuu/Loki.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Loki' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
end
