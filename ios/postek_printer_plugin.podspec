#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint postek_printer_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'postek_printer_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  
  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyIcdnfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'postek_printer_plugin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}


  # --- ****** 开始你的自定义配置 ****** ---

  # 1. 指定要链接的静态库文件
  # 路径相对于 .podspec 文件所在的位置
  s.vendored_libraries = 'Classes/PTKLib/libPTKPrintSDK.a'

  # 2. 配置 Xcode 构建选项，告诉编译器去哪里找头文件
  # 使用 pod_target_xcconfig 可以确保这些设置只应用于你的插件 Target
  s.pod_target_xcconfig = {
    # $(PODS_TARGET_SRCROOT) 是一个指向你插件源码根目录(ios目录)的变量
    # 我们将其指向存放 .h 文件的 include 目录
    'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/Classes/PTKLib"'
  }

  # 3. (如果需要) 添加静态库所依赖的系统框架或库
  # s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  # s.libraries = 'z', 'sqlite3'

  # --- ****** 自定义配置结束 ****** ---
end
