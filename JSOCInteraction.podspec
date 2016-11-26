Pod::Spec.new do |s|
  s.name     = 'JSOCInteraction'
  s.version  = '0.0.7'
 #s.license  = 'MIT'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary  = "A simple tool can easily implement the interaction between oc and js.
                You've probably never heard of it."
  s.homepage = 'https://github.com/GongChuanZan/JSOCInteraction'
  s.authors  = { 'GCZ' => 'zan999@qq.com' }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"  
  s.author = {'GCZ' => 'zan999@qq.com' }
  s.source   = { :git => 'https://github.com/GongChuanZan/JSOCInteraction.git', :tag => s.version }
  s.source_files = 'JSOCInteractionDemo/JSOCInteractionDemo/JSOCInteraction/*.{h,m}'
  s.requires_arc = true
  s.framework = 'JavaScriptCore'
end
