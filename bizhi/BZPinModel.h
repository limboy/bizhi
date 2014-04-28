//
//  BZPinModel.h
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "JSONModel.h"

@interface BZPinModel : JSONModel
@property (nonatomic, assign) NSInteger pinId;
@property (nonatomic, copy) NSString *key;

- (NSString *)imageURLWithThumbnailWidth:(NSInteger)width;
@end
