//
//  PZOVideoGameTableViewController.m
//  VG Seeker
//
//  Created by Anojh Gnanachandran on 1/12/2014.
//  Copyright (c) 2014 Anojh Gnanachandran. All rights reserved.
//

#import "PZOVideoGameTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VideoGame.h"
#import "PZOVGCell.h"
#import "Constants.h"

@interface PZOVideoGameTableViewController ()
@property NSMutableArray *videoGameList; // list of videogames in table view
@property NSMutableArray *allVideoGameList; // list of all videogames fetched
@property NSMutableData *receivedData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL hasSearched;
@property int totalPages;
@property int currentPage;
@end

@implementation PZOVideoGameTableViewController
static NSString *const BB_API_URL_WITHOUT_KEY = @"http://api.remix.bestbuy.com/v1/products(platform%20in(playstation%203,playstation%204,psp)&salePrice%3C60)?show=sku,name,salePrice,platform,image&format=json&pageSize=100&page=&sort=salesRankMediumTerm.asc&apiKey=";

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContents = searchBar.text;
    self.searchText = searchContents;
    if ([searchContents isEqualToString:@""]) {
        self.searchText = nil;
    }
    [self.videoGameList removeAllObjects];
    self.currentPage = 1;
    self.hasSearched = YES;
    [self sendHttpRequest:self.searchText];
    [self.segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContents = searchBar.text;
    self.searchText = searchContents;
    if ([searchContents isEqualToString:@""]) {
        self.searchText = nil;
        [self.videoGameList removeAllObjects];
        for (VideoGame *game in self.allVideoGameList) {
            [self.videoGameList addObject:game];
        }
        [self.segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }

    [searchBar resignFirstResponder];
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Called when server has determined that it has enough info to create NSURLResponse object
    // Can be called multiple times (e.g. in the case of a redirect), so each time, we reset the data.
    [self.receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append data
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release connection and received data by setting connection and received data to nil
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id parsedJsonData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
    if ([parsedJsonData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *parsedJsonObject = (NSDictionary *)parsedJsonData;
        self.totalPages = [[parsedJsonObject objectForKey:@"totalPages"] intValue];
        self.currentPage = [[parsedJsonObject objectForKey:@"currentPage"] intValue];
        NSArray *products = [parsedJsonObject objectForKey:@"products"];
        for (NSDictionary *jsonObject in products) {
            NSString *imageUrl = [jsonObject objectForKey:@"image"];
            NSString *gameName = [jsonObject objectForKey:@"name"];
            float salePrice = [[jsonObject objectForKey:@"salePrice"] floatValue];
            NSString *platform = [jsonObject objectForKey:@"platform"];
            VideoGame *videoGame = [[VideoGame alloc] initWithName:gameName andPlatform:platform andPrice:salePrice andImageUrlString:imageUrl];
            if (!self.hasSearched) {
                [self.allVideoGameList addObject:videoGame];
            }
            [self.videoGameList addObject:videoGame];
        }
    }
    
    [self.tableView reloadData];
    if (self.currentPage < self.totalPages) {
        self.currentPage++;
        [self sendHttpRequest:self.searchText];
    }
}

- (void)sendHttpRequest
{
    [self sendHttpRequest:nil];
}

- (void)sendHttpRequest:(NSString *)searchText
{
    // Create the request
    NSString *urlString = [[BB_API_URL_WITHOUT_KEY stringByAppendingString:API_KEY] stringByReplacingOccurrencesOfString:@"page=" withString:[NSString stringWithFormat:@"page=%d", self.currentPage]];
    
    if (searchText) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"products(" withString:[NSString stringWithFormat:@"products(name=%@*&", searchText]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]; // timeout after 60s
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        // self.receivedData = nil;
        // Connection failed
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    self.searchBar = tempSearchBar;
    [self.searchBar setShowsCancelButton:YES];
    [self.searchBar sizeToFit];
    [self.tableView setTableHeaderView:self.searchBar];
    self.searchBar.delegate = self;
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    // Instantiation code
    self.videoGameList = [[NSMutableArray alloc] init];
    self.allVideoGameList = [[NSMutableArray alloc] init];
    self.receivedData = [NSMutableData dataWithCapacity:0];
    self.currentPage = 1;
    // Send request and put data in videoGameList
    [self sendHttpRequest];
    [self.tableView registerNib:[UINib nibWithNibName:@"PZOVGCell" bundle:nil]
         forCellReuseIdentifier:@"PZOVGCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.videoGameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PZOVGCell";
    PZOVGCell *cell = (PZOVGCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    VideoGame *videoGame = self.videoGameList[indexPath.row];
    cell.nameLabel.text = [videoGame gameName];
    [cell.gameImage setImageWithURL:[videoGame imageUrl] placeholderImage:[UIImage imageNamed:@"vg-icon"]];
    cell.priceLabel.text = [videoGame priceString];
    cell.platformLabel.text = [videoGame platform];
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    VideoGame *game = [self.videoGameList objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://google.com/search?q=%@", game.gameName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}


- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    NSString *platform = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    [self.videoGameList removeAllObjects];
    for (VideoGame *game in self.allVideoGameList) {
        if ([game.platform isEqualToString:platform]) {
            [self.videoGameList addObject:game];
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
