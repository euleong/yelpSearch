//
//  RestaurantTableViewCell.h
//  yelpSearch
//
//  Created by Eugenia Leong on 3/22/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategory;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantRating;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNumReviews;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceRange;

@end