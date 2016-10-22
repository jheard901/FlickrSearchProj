//
//  WebService.m
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WebService.h"



@interface WebService ()

@end



@implementation WebService

-(void)startWebServiceRequestWithURL:(NSURL*)url
{
    NSThread *currentThread = [NSThread currentThread];
    
    __weak WebService *weakSelf = self;
    
    
    NSURLSessionDataTask* downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
        
        
        
        if (error)
        {
            if ([weakSelf.delegate respondsToSelector:@selector(webServiceFailedWithError:)])
            {
                [weakSelf.delegate performSelector:@selector(webServiceFailedWithError:) onThread:currentThread withObject:error waitUntilDone:YES];
            }
            else
            {
                NSLog(@"Web Service Failed: Missing Delegate, or self de-allocated.");
            }
        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(webServiceSucceededWithData:)])
            {
                [weakSelf.delegate performSelector:@selector(webServiceSucceededWithData:) onThread:currentThread withObject:responseData waitUntilDone:YES];
            }
            else
            {
                NSLog(@"Web Service Succeeded: Missing Delegate, or self de-allocated.");
            }
        }
    }];
        
    [downloadTask resume];
}



@end




