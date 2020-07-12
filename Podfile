source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'Recipy' do
  pod "Koloda"
end

# Pods for Recipy
	pod 'Firebase/Core'
	pod 'Firebase/Database'
	pod 'Firebase/Auth'
	pod 'GoogleSignIn'
	pod 'Firebase/Analytics'
	pod 'Firebase/Storage'
	pod 'FBSDKLoginKit'
	pod 'ProgressHUD'
	pod 'MaterialComponents'
	pod 'FacebookCore'
	pod 'FacebookLogin'
	pod 'Bolts'
	pod 'FBSDKCoreKit'
	pod 'Fabric'
	pod 'TwitterKit'
	pod 'SwiftKeychainWrapper'
	pod 'SDWebImage'
  pod 'Koloda'
  pod 'Alamofire', '~> 4.0'
#  pod 'OpenAPIClient', :path => 'Recipy/Vendor'


post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`

end
