//
//  FiltersViewController.m
//  yelpSearch
//
//  Created by Eugenia Leong on 3/22/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "FiltersViewController.h"
#import "ToggleSwitchCell.h"
#import "FilterOptionCell.h"

@interface FiltersViewController ()
@property (nonatomic, strong) NSArray *filterCategories;
@property (weak, nonatomic) IBOutlet UITableView *filtersTableView;

@end
NSString * const SWITCHES = @"switches";
NSString * const EXPAND = @"expand";
NSString * const TOGGLE_SWITCH = @"ToggleSwitchCell";
NSString * const FILTER_CELL = @"FilterOptionCell";
NSMutableDictionary *selectedCategories;
NSMutableDictionary *expandedCategories;
UIBarButtonItem *cancelButton;
UIBarButtonItem *searchButton;
NSUserDefaults *defaults;

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Filters";
        
        self.filterCategories = [NSArray arrayWithObjects:
                           @{
                                @"name":@"Most Popular",
                                @"type":@"switches",
                                @"options":@[@"Open Now",@"Hot & New",@"Offering a Deal",@"Delivery"]
                            },
                           @{
                                @"name":@"Distance",
                                @"type":@"expand",
                                @"options":@[@"Auto",@"2 blocks",@"6 blocks",@"1 mile",@"5 miles"]
                            },
                           @{
                                @"name":@"Sort By",
                                @"type":@"expand",
                                @"options":@[@"Best Match",@"Distance",@"Rating",@"Most Reviewed"]
                            },
                           @{
                                @"name":@"General Features",
                                @"type":@"switches",
                                @"options":@[@"Take-out",@"Accepts Credit Cards",@"Wheelchair Accessible",@"Full Bar",@"Beer & Wine Only",@"Happy Hour",@"Free Wi-Fi"]
                            },
                           @{
                                @"name":@"Categories",
                                @"type":@"expand",
                                @"options":@[@"American (New)", @"American (Traditional)", @"Asian Fusion", @"Barbeque", @"Breakfast & Brunch", @"Buffets", @"Burgers", @"Cafes", @"Chinese", @"Delis", @"Fast Food", @"French", @"German", @"Gluten-Free", @"Greek", @"Halal", @"Iberian", @"Indian", @"Italian", @"Japanese", @"Korean", @"Latin American", @"Malaysian", @"Mediterranean", @"Mexican", @"Middle Eastern", @"Pakistani", @"Pizza", @"Portuguese", @"Salad", @"Sandwiches", @"Seafood", @"Soul Food", @"Soup", @"Sushi Bars", @"Thai", @"Vegan", @"Vegetarian", @"Vietnamese"]
                            },
                           nil
                           ];
        
        selectedCategories = [NSMutableDictionary
                              dictionaryWithDictionary:
                              @{
                                @"Open Now" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Offering a Deal" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Hot & New" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Delivery" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Take-out" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Accepts Credit Cards" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Wheelchair Accessible" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Full Bar" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Beer & Wine Only" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Happy Hour" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}],
                                @"Free Wi-Fi" : [NSMutableDictionary dictionaryWithDictionary:@{@"selected": @NO}]
                              }];
        
        expandedCategories = [NSMutableDictionary dictionaryWithDictionary:
                              @{
                                @"Distance" : [NSMutableDictionary dictionaryWithDictionary:@{@"expanded": @NO, @"selected":@0}],
                                @"Sort By" : [NSMutableDictionary dictionaryWithDictionary:@{@"expanded":@NO, @"selected":@0}],
                                @"Categories" : [NSMutableDictionary dictionaryWithDictionary:@{@"expanded":@NO, @"selected":@35}]
                              }];
        
        defaults = [NSUserDefaults standardUserDefaults];
                                
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filtersTableView.dataSource = self;
    self.filtersTableView.delegate = self;
    
    // table view cells
    UINib *toggleSwitchNib = [UINib nibWithNibName:TOGGLE_SWITCH bundle:nil];
    [self.filtersTableView registerNib:toggleSwitchNib forCellReuseIdentifier:TOGGLE_SWITCH];
    UINib *filterOptionNib = [UINib nibWithNibName:FILTER_CELL bundle:nil];
    [self.filtersTableView registerNib:filterOptionNib forCellReuseIdentifier:FILTER_CELL];
    
    // add cancel button
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(search:)];
    [searchButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    
    //[expandedCategories[@"Distance"] setValue:[defaults integerForKey:@"Distance"] forKey:@"selected"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)search:(id)sender
{

    // save values
    for (NSString* toggleKey in selectedCategories.allKeys)
    {
            [defaults setObject:[NSNumber numberWithBool:[selectedCategories[toggleKey][@"selected"] boolValue]] forKey:toggleKey];
    }
             
    int index = [expandedCategories[@"Distance"][@"selected"] intValue];
    NSString *selectedStr = self.filterCategories[1][@"options"][index];
    [defaults setObject:selectedStr forKey:@"Distance"];
    
    index = [expandedCategories[@"Sort By"][@"selected"] intValue];
    selectedStr = self.filterCategories[2][@"options"][index];
    [defaults setObject:selectedStr forKey:@"Sort By"];
    
    index = [expandedCategories[@"Categories"][@"selected"] intValue];
    selectedStr = self.filterCategories[4][@"options"][index];
    [defaults setObject:selectedStr forKey:@"Categories"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionIndex = indexPath.section;
    NSString *labelName = self.filterCategories[indexPath.section][@"options"][indexPath.row];
    
    if (self.filterCategories[sectionIndex][@"type"] == SWITCHES)
    {
        ToggleSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:TOGGLE_SWITCH forIndexPath:indexPath];
        int selected = [defaults integerForKey:labelName];
        cell.switchName.text = labelName;
        cell.toggleSwitch.on = selected;//[selected boolValue];
        return cell;
    }
    else
    {
        FilterOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:FILTER_CELL forIndexPath:indexPath];
        NSString *sectionName = self.filterCategories[indexPath.section][@"name"];
        //NSLog(@"cellForRowAtIndexPath %@ selected index %d", sectionName, [expandedCategories[sectionName][@"selected"] integerValue]);
        if (![expandedCategories[sectionName][@"expanded"] boolValue])
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        // expanded
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];

        }
        
        cell.filterOptionName.text = labelName;
        return cell;
    }

}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * filterCategory = self.filterCategories[section][@"type"];
    if ( filterCategory == SWITCHES)
    {
        return [self.filterCategories[section][@"options"] count];
    }
    else if (filterCategory == EXPAND)
    {
        NSString * sectionName = self.filterCategories[section][@"name"];
        if ([expandedCategories[sectionName][@"expanded"] boolValue])
        {
            return [self.filterCategories[section][@"options"] count];
        }
        else
        {
            return 1;
        }

    }
    return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filterCategories.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.filterCategories[section][@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.filtersTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sectionIndex = indexPath.section;
    if (self.filterCategories[sectionIndex][@"type"] == EXPAND)
    {
        NSString *categoryName = self.filterCategories[sectionIndex][@"name"];
        BOOL isExpanded = ![expandedCategories[categoryName][@"expanded"] boolValue];
    
        [expandedCategories[categoryName] setValue:[NSNumber numberWithBool:isExpanded] forKey:@"expanded"];
        
        //NSLog(@"didSelectRowAtIndexPath %@ selected index %d", categoryName, [expandedCategories[categoryName][@"selected"] integerValue]);
        
        if (isExpanded == YES)
        {
            NSMutableArray* rows = [NSMutableArray array];
            int prevSelectedIndex = [expandedCategories[categoryName][@"selected"] integerValue];
            NSString *selectedStr = self.filterCategories[indexPath.section][@"options"][prevSelectedIndex];
            for (int i = 0; i < [self.filterCategories[sectionIndex][@"options"] count]; i++) {
                
                if (self.filterCategories[indexPath.section][@"options"][i] == selectedStr)
                {
                    continue;
                }
                
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section];
                [rows addObject:newIndexPath];
            }
            
            [self.filtersTableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSMutableArray* rows = [NSMutableArray array];
            [expandedCategories[categoryName] setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"selected"];
            FilterOptionCell *cell = (FilterOptionCell*)[self.filtersTableView cellForRowAtIndexPath:indexPath];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            for (int i = 0; i < [self.filterCategories[sectionIndex][@"options"] count]; i++) {
                
                if (indexPath.row == i)
                {
                    continue;
                }
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [rows addObject:newIndexPath];
            }
            
            [self.filtersTableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
