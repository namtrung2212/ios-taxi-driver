# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!


def pod_Global

	use_frameworks!

	platform :ios, '9.3'
end


def pod_Util
	pod 'ObjectMapper', '~> 1.2'
	pod 'SwiftyJSON', '~> 2.3.2'
	pod 'JSONWebToken'
	pod 'CryptoSwift'

end

def pod_ClientDB
	pod 'RealmSwift', '~> 0.100.0'
end

def pod_UI
	pod 'DKImagePickerController', '~> 3.1.3'
	pod 'DTCollectionViewManager', '~> 4.5.2'
	pod 'DTTableViewManager', '~> 4.5.3'
	pod 'JSQNotificationObserverKit', '~> 4.0.0'
	pod 'EasyAnimation', '~> 1.0.5'
	pod 'PageMenu', '~> 1.2.9'
	pod 'HidingNavigationBar', '~> 0.3.0'
	pod 'SCLAlertView'
end

def pod_Network
	pod 'Alamofire', '~> 3.2'
	pod 'Socket.IO-Client-Swift', '~> 6.0.0'
	pod 'AlamofireObjectMapper', '~> 3.0'
	pod 'AlamofireImage', '~> 2.4.0'
	pod 'AlamofireSwiftyJSON', '~> 0.1.0'
	pod 'AlamofireNetworkActivityIndicator', '~> 1.0'
end

def pod_Map
	  pod 'GoogleMaps', '~> 1.13.1'
end

workspace 'pods.xcworkspace'

target ’Pods-SCONNECTING’ do
		project 'Pods/Pods.xcodeproj'
		pod_Global
		pod_Util
		pod_ClientDB
		pod_Network
		pod_UI
		pod_Map
end
