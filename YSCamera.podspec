Pod::Spec.new do |s|
  s.name = 'YSCamera'
  s.version = '0.0.2'
  s.summary = 'Simple Camera Using UIImagePickerController.'
  s.homepage = 'https://github.com/yusuga/YSCamera'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSCamera.git', :tag => s.version.to_s }
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Classes/YSCamera/**/*.{h,m}'
  s.resources    = 'Classes/YSCamera/**/*.{lproj}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
  
  s.dependency 'MRProgress'
end