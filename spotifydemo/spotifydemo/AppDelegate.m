//
//  AppDelegate.m
//  spotifydemo
//
//  Created by Eric Sze on 9/21/15.
//  Copyright © 2015 myapps. All rights reserved.
//

#import "AppDelegate.h"
#import <Spotify/Spotify.h>

@interface AppDelegate ()

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SPTAuth defaultInstance] setClientID:@"2fbb13f0bec54889b9cb9cf6656776ef"];
    [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:@"spotifydemo://returnAfterLogin"]];
    [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
    
//    // Construct a login URL and open it
//    NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
//    
//    // Opening a URL in Safari close to application launch may trigger
//    // an iOS bug, so we wait a bit before doing so.
//    [application performSelector:@selector(openURL:)
//                      withObject:loginURL afterDelay:0.1];
    
    return YES;
    
}

// Handle auth callback
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }
            
            // Call the -playUsingSession: method to play a track
            [self playUsingSession:session];
        }];
        return YES;
    }
    
    return NO;
}

-(void)playUsingSession:(SPTSession *)session {
    
    // Create a new player if needed
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID];
    }
    
    [self.player loginWithSession:session callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in got error: %@", error);
            return;
        }
        
        NSURL *trackURI = [NSURL URLWithString:@"spotify:track:7wqSzGeodspE3V6RBD5W8L"];
        [self.player playURIs:@[ trackURI ] fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
        }];
    }];
}

@end
