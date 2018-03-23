//
//  SWBProxyProtocol.m
//  shadowsocks
//
//  Created by Zhang Yuanming on 1/8/18.
//  Copyright © 2018 clowwindy. All rights reserved.
//

#import "SWBProxyProtocol.h"

static NSURLSession *session;

@interface SWBProxyProtocol() <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation SWBProxyProtocol

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (void) setHost:(NSString *)host Port:(int)port
{
    ssLocalPort = port;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return YES;
}

- (void)startLoading
{

    //这里拦截所有请求，给请求配置一个configuration
    if (!session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.connectionProxyDictionary =
        @{(NSString *)kCFStreamPropertySOCKSProxyHost: @"127.0.0.1",
          (NSString *)kCFStreamPropertySOCKSProxyPort: @(ssLocalPort)};
        session = [NSURLSession sessionWithConfiguration:configuration];
    }
    NSLog(@"%@", self.request.URL);
    __weak typeof(self)weakSelf = self;
    self.task = [session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@ - %@", self.request.URL, error);
        if (error) {
            [weakSelf.client URLProtocol:weakSelf didFailWithError:error];
        } else {
            [weakSelf.client URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [weakSelf.client URLProtocol:weakSelf didLoadData:data];
            [weakSelf.client URLProtocolDidFinishLoading:weakSelf];
        }
    }];
    [self.task resume];
}

- (void)stopLoading
{
    [self.task cancel];
}

+ (void) setPACURL:(NSString *)pacURL
{

}

@end
