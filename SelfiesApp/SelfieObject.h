//
//  SelfieObject.h
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SelfieObject : NSObject


@property (strong, nonatomic) NSString *strURLThumb;
@property (strong, nonatomic) NSString *strURLLowRes;
@property (strong, nonatomic) NSString *strURLStdRes;
@property (strong, nonatomic) UIImage *imgThumb;
@property (strong, nonatomic) UIImage *imgLowRes;
@property (strong, nonatomic) UIImage *imgStdRes;
@property (strong, nonatomic) NSString *strFromUser;


- (instancetype)initWithImageURL:(NSString*)imgURL;

@end



