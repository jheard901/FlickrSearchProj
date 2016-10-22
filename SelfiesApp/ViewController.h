//
//  ViewController.h
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "JsonParse.h"
#import "SelfieObject.h"

/* all bugs fixed, app has been optimized to use concurrency, can search for different tags, and has infinite scrolling. Additional quality of life updates made to app as well */

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, webServiceDelegate, JsonParseDelegate, UISearchBarDelegate, UIScrollViewDelegate>




@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;


-(void) reloadVisibleCells;
-(void) initiateAppendRequest;
-(void) appendArrayWithContents:(NSMutableArray*)contents;


@end



