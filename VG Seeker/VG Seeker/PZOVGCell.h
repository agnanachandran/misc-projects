//
//  PZOVGCell.h
//  VG Seeker
//
//  Created by Anojh Gnanachandran on 1/19/2014.
//  Copyright (c) 2014 Anojh Gnanachandran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZOVGCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@end
