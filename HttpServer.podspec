
Pod::Spec.new do |s|
  s.name         = "HttpServer"
  s.version      = "0.0.1"
  s.summary      = "A short description of HttpServer."
  s.description  = "This is a test demo”
  s.homepage     = "http://EXAMPLE/HttpServer"
  s.license      = "MIT"
  s.author       = { "guorenqing" => "guo.renqing@163.com" }
  s.platform     = :ios, “6.0”
  s.ios.deployment_target = “6.0”
  s.source       = { :git => "http://EXAMPLE/HttpServer.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true
  s.dependency  AFNetworking', '~> 2.5.4'

end
