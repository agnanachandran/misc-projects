//
//  VideoGame.h
//  VG Seeker
//
//  Created by Anojh Gnanachandran on 1/12/2014.
//  Copyright (c) 2014 Anojh Gnanachandran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoGame : NSObject
@property NSString *gameName;
@property NSString *platform;
@property NSString *priceString;
@property NSURL *imageUrl;

- (VideoGame *)initWithName:(NSString *)name
                andPlatform:(NSString *)platform
                   andPrice:(float)price
                andImageUrlString:(NSString *)imageUrl;
@end
