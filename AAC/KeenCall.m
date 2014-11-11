//
//  KeenCall.m
//  AAC
//
//  Created by Byrdann Fox on 11/11/14.
//  Copyright (c) 2014 ExcepApps, Inc. All rights reserved.
//

#import "KeenCall.h"
#import "KeenClient.h"
#import "KeenProperties.h"
#import "KIOEventStore.h"

@implementation KeenCall

-(void)keenAuth:(NSString *)projectKey :(NSString *)writeKey :(NSString *)readKey {
    
    [KeenClient sharedClientWithProjectId:projectKey
                              andWriteKey:writeKey andReadKey:readKey];
    
}

-(void)keenEvent:(NSDictionary *)dictionary {
    
    [[KeenClient sharedClient] addEvent:dictionary toEventCollection:@"sentence_spoken" error:nil];
    
    [[KeenClient sharedClient] uploadWithFinishedBlock:^(void) {
    
        NSLog(@"KEEN.IO...");
        
    }];

}

@end