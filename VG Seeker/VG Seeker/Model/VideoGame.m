//
//  VideoGame.m
//  VG Seeker
//
//  Created by Anojh Gnanachandran on 1/12/2014.
//  Copyright (c) 2014 Anojh Gnanachandran. All rights reserved.
//

#import "VideoGame.h"

@implementation VideoGame

- (VideoGame *)initWithName:(NSString *)name
                andPlatform:(NSString *)platform
                   andPrice:(float)price
          andImageUrlString:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        self.gameName = name;
        self.platform = platform;
        NSString *priceString = [NSString stringWithFormat:@"%.02f", price];
        self.priceString = priceString;
        self.imageUrl = [[NSURL alloc] initWithString:imageUrl];
    }
    return self;
}

@end
