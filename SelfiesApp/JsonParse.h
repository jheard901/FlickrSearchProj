//
//  JsonParse.h
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JsonParseDelegate <NSObject>

-(void)jsonParseSucceededWithObjects:(NSMutableArray*)parsedObjects;
-(void)jsonParseFailedWithError:(NSError*)parseError;

@end




@interface JsonParse : NSObject

@property (weak,nonatomic) id delegate;

-(void)startParsingData:(NSData*)jsonData;

@end




