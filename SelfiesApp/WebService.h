//
//  WebService.h
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol webServiceDelegate <NSObject>

-(void)webServiceSucceededWithData:(NSData*)responseData;
-(void)webServiceFailedWithError:(NSError*)error;

@end



@interface WebService : NSObject

@property (weak, nonatomic)id delegate;

-(void)startWebServiceRequestWithURL:(NSURL*)url;

@end



