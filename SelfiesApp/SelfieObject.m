//
//  SelfieObject.m
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "SelfieObject.h"



@implementation SelfieObject


- (instancetype)initWithImageURL:(NSString *)imgURL
{
    self = [super init];
    if(self)
    {
        _strURLLowRes = imgURL;
    }
    return self;
}

@end


