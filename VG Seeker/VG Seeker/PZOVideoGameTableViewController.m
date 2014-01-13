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

@interface PZOVideoGameTableViewController ()
@property NSMutableArray *videoGameList; // list of videogames fetched from
@property NSMutableData *receivedData;
@end

@implementation PZOVideoGameTableViewController
static NSString *const FULL_URL = @"http://api.remix.bestbuy.com/v1/products(name=headphones*&name!=Dre*)?show=sku,name,salePrice,image&format=json&pageSize=100&sort=salePrice.dsc&apiKey=q3z2rf7eskg47b78xnwqxcvq";
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
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    id parsedJsonData = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
    if ([parsedJsonData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *parsedJsonObject = (NSDictionary *)parsedJsonData;
        NSArray *products = [parsedJsonObject objectForKey:@"products"];
        for (NSDictionary *jsonObject in products) {
            NSString *imageUrl = [jsonObject objectForKey:@"image"];
            NSString *gameName = [jsonObject objectForKey:@"name"];
            float salePrice = [[jsonObject objectForKey:@"salePrice"] floatValue];
//            NSString *sku = [jsonObject objectForKey:@"sku"];
            VideoGame *videoGame = [[VideoGame alloc] initWithName:gameName andPlatform:@"TODO" andPrice:salePrice andImageUrlString:imageUrl];
            [self.videoGameList addObject:videoGame];
        }
    }
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)sendHttpRequest
{
    // Create the request
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:FULL_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0]; // timeout after 60s
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        // self.receivedData = nil;
        // Connection failed
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Instantiation code
    self.videoGameList = [[NSMutableArray alloc] init];
    self.receivedData = [NSMutableData dataWithCapacity:0];
    
    // Send request and put data in videoGameList
    [self sendHttpRequest];
    
    // pre populate videoGameList
    // [self.videoGameList addObject:[[VideoGame alloc] initWithName:@ "Loading..." andPlatform:@"PS2" andPrice:3.00 andImageUrlString:@"http://google.ca"]];
    [[self tableView] reloadData];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.videoGameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    VideoGame *videoGame = self.videoGameList[indexPath.row];
    cell.textLabel.text = [videoGame gameName];
    [cell.imageView setImageWithURL:[videoGame imageUrl] placeholderImage:[UIImage imageNamed:@"headphone-icon"]];
    return cell;
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
