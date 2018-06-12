
#import "FDKeychain.h"
#import "FDKeychainPlugin.h"

@implementation FDKeychainPlugin
- (void) get:(CDVInvokedUrlCommand*)command {
  [self.commandDelegate runInBackground:^{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;

    NSString *key = [arguments objectAtIndex:0];
    NSString *service = @"MyApplication";
    NSString *accessGroup = nil;
    NSError *error = nil;
    NSString *value = [FDKeychain itemForKey: key
                                  forService: service
                               inAccessGroup: accessGroup
                                       error: &error];
    if (error != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    }
      
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) getRaw:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* arguments = command.arguments;
        CDVPluginResult* pluginResult = nil;

        NSString *key = [arguments objectAtIndex:0];
        NSString *service = @"MyApplication";
        NSString *accessGroup =  nil;
        NSError *error = nil;
        NSData *value = [FDKeychain rawDataForKey: key
                                      forService: service
                                   inAccessGroup: accessGroup
                                           error: &error];
        if (error != nil) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:value];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) set:(CDVInvokedUrlCommand*)command {
  [self.commandDelegate runInBackground:^{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;


    NSString *key = [arguments objectAtIndex:0];
    NSString *value = [arguments objectAtIndex:1];
    NSString *service = @"MyApplication";
    BOOL access = true;
    NSString *accessGroup =  nil;
    NSError *error = nil;
      
    BOOL success = [FDKeychain saveItem: value
                                 forKey: key
                             forService: service
                          inAccessGroup: accessGroup
                      withAccessibility: (access)? FDKeychainAccessibleWhenUnlocked : FDKeychainAccessibleAfterFirstUnlock
                                  error: &error];

    if (success) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@" %@ successfully saved", key]];
    }else{
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
    }
      
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) remove:(CDVInvokedUrlCommand*)command {
  [self.commandDelegate runInBackground:^{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;

    if([arguments count] < 2) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
      messageAsString:@"incorrect number of arguments for remove"];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      return;
    }

    NSString *key = [arguments objectAtIndex:0];
    NSString *service = @"MyApplication";
    NSString *accessGroup = nil;
    NSError *error = nil;
      
    BOOL success = [FDKeychain deleteItemForKey: key
                                     forService: service
                                  inAccessGroup: accessGroup
                                          error: &error];
      
    if (success) {
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@" %@ successfully removed", key]];
    }else{
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

@end