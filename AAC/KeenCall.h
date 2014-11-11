//
//  KeenCall.h
//  AAC
//
//  Created by Byrdann Fox on 11/11/14.
//  Copyright (c) 2014 ExcepApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeenCall : NSObject

-(void)keenAuth:(NSString *)projectKey :(NSString *)writeKey :(NSString *)readKey;
-(void)keenEvent:(NSDictionary *)dictionary;

@end