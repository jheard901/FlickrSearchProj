//
//  JsonParse.m
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "JsonParse.h"
#import "SelfieObject.h"



@implementation JsonParse

-(void)startParsingData:(NSData*)jsonData
{
    NSThread *currentThread = [NSThread currentThread];
    
    __weak JsonParse *weakSelf = self;
    
    
    
    
    NSMutableArray *resultObjects = [[NSMutableArray alloc]init];
    
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    //NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (error)
    {
        if ([weakSelf.delegate respondsToSelector:@selector(jsonParseFailedWithError:)])
        {
            [weakSelf.delegate performSelector:@selector(jsonParseFailedWithError:) onThread:currentThread withObject:error waitUntilDone:YES];
        }
        else
        {
            NSLog(@"Parse Failed. No delegate method or self de-allocated.");
        }
    }
    else
    {
        /* utilize an online JSON viewer for interpreting data */
        
        NSDictionary* photos = [jsonDict objectForKey:@"photos"];
        NSArray* photo = [photos objectForKey:@"photo"];
        
        for(NSDictionary* diction in photo)
        {
            //info based on: http://blog.mugunthkumar.com/coding/ios-tutorial-image-cache-and-loading-thumbnails-using-mknetworkkit/
            
            //get the title
            NSString* title = [diction objectForKey:@"title"];
            
            //get the author
            NSString* author = [diction objectForKey:@"owner"];
            
            //get info to prepare for loading the image
            NSString* farm = [diction objectForKey:@"farm"];
            NSString* server = [diction objectForKey:@"server"];
            NSString* _id = [diction objectForKey:@"id"];
            NSString* secret = [diction objectForKey:@"secret"];
            
            //get the url for image
            NSString* imageURL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", farm, server, _id, secret];
            
#warning This could be expanded on by enlarging the image and displaying the "title" and "owner" for it when it is selected
            
            //make a new Selfie object here
            SelfieObject* selfieObject = [[SelfieObject alloc] initWithImageURL:imageURL];
            [resultObjects addObject:selfieObject];
        }
        
        
        if ([weakSelf.delegate respondsToSelector:@selector(jsonParseSucceededWithObjects:)])
        {
            [weakSelf.delegate performSelector:@selector(jsonParseSucceededWithObjects:) onThread:currentThread withObject:resultObjects waitUntilDone:YES];
        }
        else
        {
            NSLog(@"Parse Finished. No delegate method or self de-allocated.");
        }
        
    }
}




@end







