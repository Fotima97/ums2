#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
   FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"com.project.ums/call"
                                          binaryMessenger:controller];
 [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
   NSString *number=call.arguments;
    // TODO
  if ([@"callNumber" isEqualToString:call.method]) {

  }

  }];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
