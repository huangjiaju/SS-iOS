//
//  SWBProxyProtocol.h
//  shadowsocks
//
//  Created by Zhang Yuanming on 1/8/18.
//  Copyright © 2018 clowwindy. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger ssLocalPort;

@interface SWBProxyProtocol : NSURLProtocol

+ (void) setHost:(NSString *)host Port:(int)port;
+ (void) setPACURL:(NSString *)pacURL;

@end
