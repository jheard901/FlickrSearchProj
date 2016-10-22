//
//  ViewController.m
//  SelfiesApp
//
//  Created by Mobile Apps Company on 8/1/14.
//  Modified by Javier Heard on 10/19/16.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "ViewController.h"
#import "Key.h"


#warning When the internet connection is poor, this app will not function properly.


//following along this tut: http://blog.mugunthkumar.com/coding/ios-tutorial-image-cache-and-loading-thumbnails-using-mknetworkkit/
//info on performing searches with Flickr api: https://www.flickr.com/services/api/flickr.photos.search.html

//for hiding the api_key, you can make a separate .h file to keep it in and add that file to a .gitignore so it is not tracked (therefore not visible to people that utilize your source), then you include that file and reference the variable to that key in this one


#define PAGE_LIMIT @"100"
#define FLICKR_IMAGES_URL(_TAG_, _PAGE_) [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=%@&format=json&nojsoncallback=1&page=%@", FLICKR_KEY, _TAG_, PAGE_LIMIT, _PAGE_]


//this url works (how to set up the URL from: https://digitalleaves.com/blog/2014/09/tutorial-interacting-with-a-flickr-restful-api-by-showing-photos-in-a-map-and-reacting-to-the-user/ )
//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=26b3fdd51d1df4125477dc85f40f0665&tags=selfie&per_page=200&format=json&nojsoncallback=1

//for easily converting int to string for changing pages in api search
#define convertedPage(_PG_) [NSString stringWithFormat:@"%li", _PG_]




@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *arrCollectionData;
@property (strong, nonatomic) WebService *myWebService;
@property (strong, nonatomic) JsonParse *myJsonParser;
@property (strong, nonatomic) NSURL *currentURL;

@end





@implementation ViewController
{
    BOOL bSearchQueried;
    BOOL bAppendRequest;
    NSString* currentTag;
    NSInteger currentPage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //change scroll view settings for keyboard dismissal
    _collectionViewMain.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; //from: http://stackoverflow.com/questions/5143873/dismissing-the-keyboard-in-a-uiscrollview
    
    //setup searchbar
    _searchBar.delegate = self;
    bSearchQueried = NO;
    
    //initialize json parser
    _myJsonParser = [[JsonParse alloc] init];
    _myJsonParser.delegate = self;
    
    //initialize web service
    _myWebService = [[WebService alloc]init];
    [_myWebService setDelegate:self];
    
    //specify default settings
    bSearchQueried = YES;
    bAppendRequest = NO;
    currentTag = @"selfie";
    currentPage = 1; //default to page 1 on new search
    
    //url source for json input
    _currentURL = [NSURL URLWithString:FLICKR_IMAGES_URL(currentTag, convertedPage((long)currentPage))];
    [_myWebService startWebServiceRequestWithURL:_currentURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search bar functions

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}

//perform a search when search button is clicked and there is no active search query
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(!bAppendRequest)
    {
        if(!bSearchQueried)
        {
            //update query
            bSearchQueried = YES;
            
            //concantenate spaces in the search text (should probably remove a whole set of characters (ie & and ;), specifically ones that could be inserted to interface with the flickr api functionality
            currentTag = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            currentPage = 1;
            
            //perform the new search now
            NSURL* newURL = [NSURL URLWithString:FLICKR_IMAGES_URL(currentTag, convertedPage((long)currentPage))];
            [_myWebService startWebServiceRequestWithURL:newURL];
            
            //NOTE: query gets reset in -(void)jsonParseSucceededWithObject and some other delegate functions
        }
    }
    
    
    [self.view endEditing:YES];
}


//where is this button?
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

#pragma mark - Collection View Functions

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrCollectionData count];
}

//the closest I can get to a shorthand for closing editing if tapping elsewhere on the screen to hide keyboard
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0)
    {
        return CGSizeMake(300, 300);
    }
    else
    {
        return CGSizeMake(145, 145);
    }
}


//where images are downloaded at
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reUseID = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUseID forIndexPath:indexPath];
    
    //load image into cell for display.
    SelfieObject *currentSelfie = [_arrCollectionData objectAtIndex:indexPath.row];
    
    //cell.alpha = 0; //remove the below if...else to force cell to have cell.alpha of 0
    
    //this hack works...
    if(cell.alpha < 1.1f && cell.alpha > 0.9f) //floating precision matters...
    {
        //skip changing a cell already displaying image
    }
    else
    {
        cell.alpha = 0;
    }
    
    
    
    //if it already has a value, then use that
    if (currentSelfie.imgLowRes)
    {
        //not gonna lie, im just hacking now
        if(cell.alpha < 1.1f && cell.alpha > 0.9f)
        {
            UIImageView *imgVw = [[UIImageView alloc] initWithImage:currentSelfie.imgLowRes];
            [cell setBackgroundView:imgVw];
            cell.alpha = 1.0f;
        }
        else
        {
            UIImageView *imgVw = [[UIImageView alloc] initWithImage:currentSelfie.imgLowRes];
            [cell setBackgroundView:imgVw];
            [UIView animateWithDuration:0.25 animations:^{ cell.alpha = 1.0f; }];
        }
        
        //originally, there was no if...else statement above, just these lines in the if statement
        //UIImageView *imgVw = [[UIImageView alloc] initWithImage:currentSelfie.imgLowRes];
        //[cell setBackgroundView:imgVw];
        //cell.alpha = 1.0f;
    }
    //otherwise dl the image based off url
    else
    {
        //perform in background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL* imgUrl = [NSURL URLWithString:currentSelfie.strURLLowRes];
            if(imgUrl)
            {
                NSData* imgData = [NSData dataWithContentsOfURL:imgUrl];
                
                if(imgData)
                {
                    currentSelfie.imgLowRes = [UIImage imageWithData:imgData];
                }
                else
                {
                    NSLog(@"Thread exception occurred on downloading the image");
                }
            }
            else
            {
                NSLog(@"Thread exception occurred on getting the image url");
            }
            
            
            //now perform ui update in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UICollectionViewCell* updatedCell = [_collectionViewMain cellForItemAtIndexPath:indexPath];
                [updatedCell setBackgroundView:[[UIImageView alloc]initWithImage:currentSelfie.imgLowRes]];
                
                [UIView animateWithDuration:0.25 animations:^{
                    updatedCell.alpha = 1.0f;
                }];
            });
            
        });
    }
    

    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //this is when a visible cell is scrolled off the view. This could be used to determine when we should release images for cells that are no longer in view
}

- (void)reloadVisibleCells
{
    
    [_collectionViewMain reloadData];
    
    
    //the below method for only reloading current visible cells not working out too well...
    /*
    for(int i = 0; i < [[_collectionViewMain visibleCells] count]; i++)
    {
        if (((UICollectionViewCell*)[[_collectionViewMain visibleCells] objectAtIndex:i]).backgroundView)
        {
            //this cell has something displaying for its image if true
        }
        else
        {
            //otherwise it needs to refresh
            NSIndexPath* indexPath = [_collectionViewMain indexPathForCell:[[_collectionViewMain visibleCells] objectAtIndex:i]];
            [_collectionViewMain reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
    */
}

#pragma mark - Scrolling

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self reloadVisibleCells];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self reloadVisibleCells];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self reloadVisibleCells];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadVisibleCells];
}


//info from: http://stackoverflow.com/questions/7706152/iphone-knowing-if-a-uiscrollview-reached-the-top-or-bottom
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //this checks where the position of the user is at in the scroll view, basically
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    float bufferSize = scrollContentSizeHeight * 0.1;
    
    if (scrollOffset <= bufferSize) //we could say = 0, but lets give it some buffer
    {
        // then we are at the top of scroll view
    }
    else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight - bufferSize)
    {
        // then we are at the end of scroll view
        if(!bAppendRequest)
        {
            [self initiateAppendRequest];
        }
    }
}


#pragma mark - Web Service Delegate Methods
-(void)webServiceSucceededWithData:(NSData *)responseData
{
    
    if(bSearchQueried)
    {
        NSLog(@"%@",[[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding]);
        [_myJsonParser startParsingData:responseData];
    }
}



-(void)webServiceFailedWithError:(NSError *)error
{
    //reset the query since it is done now
    bSearchQueried = NO;
    bAppendRequest = NO;
    
    NSLog(@"Web service request failed.");
}



#pragma mark - Json Parse Delegate Methods
-(void)jsonParseSucceededWithObjects:(NSMutableArray *)parsedObjects
{
    if(bSearchQueried)
    {
        
        [self appendArrayWithContents:[parsedObjects copy]];
        
        /* original code w/o factoring an append request
        //initialize arrCollectionData with the parsed results
        _arrCollectionData = [[NSMutableArray alloc] initWithArray:[parsedObjects copy]];
        
        //reset the search query
        bSearchQueried = NO;
        
        //when this reload happens, that is when the cells will start to download images in the cellForItemAtIndexPath function
        [_collectionViewMain reloadData];
         */
    }
    
}



-(void)jsonParseFailedWithError:(NSError *)parseError
{
    //reset the query since it is done now
    bSearchQueried = NO;
    bAppendRequest = NO;
}


#pragma mark - Adding data to collection view array

//initiates request to add data to array (for infinite scrolling)
- (void)initiateAppendRequest
{
    //set request
    bSearchQueried = YES;
    bAppendRequest = YES;
    
    //increment to next page
    currentPage++;
    
    //perform search with same tag
    NSURL* newURL = [NSURL URLWithString:FLICKR_IMAGES_URL(currentTag, convertedPage((long)currentPage))];
    [_myWebService startWebServiceRequestWithURL:newURL];
}


- (void)appendArrayWithContents:(NSMutableArray *)contents
{
    //this is a new search
    if (!bAppendRequest) {
        
        //initialize arrCollectionData with the parsed results
        _arrCollectionData = nil;
        _arrCollectionData = [[NSMutableArray alloc] initWithArray:contents];
        
        //reset the search query
        bSearchQueried = NO;
        
        //when this reload happens, that is when the cells will start to download images in the cellForItemAtIndexPath function
        [_collectionViewMain reloadData];
    }
    //this is an append request
    else
    {
        [_arrCollectionData addObjectsFromArray:contents];
        
        bSearchQueried = NO;
        bAppendRequest = NO;
        
        [_collectionViewMain reloadData];
    }
}





@end








