
Pod::Spec.new do |s|

  s.name         = "QRTextLib"
  s.version      = "0.0.3"
  s.summary      = "基本类别的集合"
  s.description  = "提供了 Foundation ,UIKit 下常用的一些分类和方法,作为一个基础库方便开发者使用,整合了自己写的一些项目里的分类,以及从 YYCategorys 中提取了一些方法的代码."

  s.homepage     = "https://github.com/xiaoxin112/QRTextLib"

  s.license      = "MIT"

  s.author             = { "lixin" => "1123586429@qq.com" }

  s.source       = { :git => "https://github.com/xiaoxin112/QRTextLib.git", :tag => "0.0.3" }
  s.ios.deployment_target = '8.0'
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 3.1.0'
end
