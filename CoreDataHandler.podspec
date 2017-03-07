
Pod::Spec.new do |s|
  s.name         = "CoreDataHandler"
  s.version      = "0.1.0"
  s.summary      = "This is a coredata operate framework"
  s.description  = "This is a coredata operate framework"
  s.homepage     = "http://www.auu.space"
  s.source       = { :git => "https://github.com/JyHu/CoreDataHandler.git", :tag => "0.1.0" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "JyHu" => "auu.aug@gmail.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source_files  = "CoreDataHandler/**/*.{h,m,mm}"
  
end
