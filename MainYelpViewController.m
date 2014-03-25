//
//  MainYelpViewController.m
//  yelpSearch
//
//  Created by Eugenia Leong on 3/22/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "MainYelpViewController.h"
#import "RestaurantTableViewCell.h"
#import "YelpClient.h"
#import "UIImageView+AFNetworking.h"

NSString * const CELL_IDENTIFIER = @"RestaurantTableViewCell";
NSInteger const RESTAURANT_LABEL_WIDTH = 130;
NSInteger const CELL_HEIGHT_EXTRA = 80;
NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";
NSArray * restaurants;
UIBarButtonItem *filterButton;

@interface MainYelpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *restaurantsTableView;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong ,nonatomic) NSMutableDictionary *parameters;
@end

@implementation MainYelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.parameters = [[NSMutableDictionary alloc] init];
        self.parameters[@"term"] = @"Thai";
        self.parameters[@"location"] = @"San Francisco";
        //[self searchYelp:@"Thai"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.restaurantsTableView.dataSource = self;
    self.restaurantsTableView.delegate = self;
    
    UINib *customNib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.restaurantsTableView registerNib:customNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    // add filter button
    filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(filter:)];
    [filterButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    // add search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[self searchYelp:[defaults valueForKey:@"Categories"]];
    NSLog(@"search parameters %@", self.parameters);
    [self searchYelpWithParameters:self.parameters];
    /*
    NSString *searchTerm = [NSString stringWithFormat:@"%@",self.parameters[@"term"]];
    [self searchYelp:searchTerm];
     */
    self.searchBar.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    // set restaurant name label
    cell.restaurantName.text = restaurants[indexPath.row][@"name"];

    // set address label
    id locationObject = restaurants[indexPath.row][@"location"];
    id addressObject = [locationObject objectForKey:@"address"];
    id neighborhoodsObject = [locationObject objectForKey:@"neighborhoods"];
    
    NSString *address = @"";
    if (addressObject && [addressObject count])
    {
        address = addressObject[0];
    }
    
    
    NSString *neighborhood = @"";
    if (neighborhoodsObject && [neighborhoodsObject count])
    {
        neighborhood = neighborhoodsObject[0];
    }

    NSString *addressFormatStr = @"%@%@";
    if ([address length] && [neighborhood length])
    {
        addressFormatStr = @"%@, %@";
    }
    cell.restaurantAddress.text = [NSString stringWithFormat:addressFormatStr, address, neighborhood];

    
    // set image
    [cell.restaurantImage setImageWithURL:[NSURL URLWithString:restaurants[indexPath.row][@"image_url"]] placeholderImage:[UIImage imageNamed:cell.restaurantName.text]];
    
    // set category label
    // TODO loop through all categories
    id categoriesObject = restaurants[indexPath.row][@"categories"];
    NSString *categoriesStr = [NSString stringWithFormat:@"%@",categoriesObject[0][0]];
    cell.restaurantCategory.text = [NSString stringWithFormat:@"%@", categoriesStr];
    
    //set restaurant rating
    [cell.restaurantRating setImageWithURL:[NSURL URLWithString:restaurants[indexPath.row][@"rating_img_url"]]];
    
    //set number of reviews
    cell.restaurantNumReviews.text = [NSString stringWithFormat:@"%@ reviews", restaurants[indexPath.row][@"review_count"]];
    
    // hide since API doesn't provide price range
    cell.restaurantPriceRange.hidden = YES;
    cell.restaurantDistance.hidden = YES;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *restaurant = restaurants[indexPath.row];
    NSString* restaurantNameStr = [NSString stringWithFormat:@"%@",restaurant[@"name"]];
    UIFont *font = [UIFont boldSystemFontOfSize: 12];
    CGRect rect = [restaurantNameStr boundingRectWithSize:CGSizeMake(RESTAURANT_LABEL_WIDTH, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.height + CELL_HEIGHT_EXTRA;
}

- (void) searchYelp:(NSString *)searchTerm
{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:searchTerm success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        restaurants = [response  objectForKey:@"businesses"];
        //NSLog(@"businesses: %@", restaurants);
        [self.restaurantsTableView reloadData];
        // TODO scroll back to top of list
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void) searchYelpWithParameters:(NSDictionary *)parameters
{
 
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        restaurants = [response  objectForKey:@"businesses"];
        //NSLog(@"businesses: %@", restaurants);
        [self.restaurantsTableView reloadData];
        // TODO scroll back to top of list
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

-(void)filter:(id)sender
{
    FiltersViewController *fvc = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil];
    fvc.delegate = self;
    
    [[self navigationController] pushViewController:fvc animated:YES];
    //[self.navigationController pushViewController:fvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    [self.restaurantsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchYelp:searchBar.text];
}

- (void)addItemViewController:(FiltersViewController *)controller setCategory:(NSString *)category
{
    //NSLog(@"This was returned from FiltersViewController %@",category);
    self.parameters[@"term"] = category;
}

- (void)addItemViewController:(FiltersViewController *)controller setSwitches:(NSDictionary *)switches
{
    // this is the only switch filter that api supports
    self.parameters[@"deals_filter"] = switches[@"Offering a Deal"];
}

- (void)addItemViewController:(FiltersViewController *)controller setDistance:(NSString *)distance
{
    self.parameters[@"distance"] = distance;
}

- (void)addItemViewController:(FiltersViewController *)controller setSortBy:(NSInteger)sortBy
{
    self.parameters[@"sort"] = @(sortBy);
}

@end
