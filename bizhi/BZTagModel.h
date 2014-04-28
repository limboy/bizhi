//
//  BZTagModel.h
//  bizhi
//
//  Created by Limboy on 4/28/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "JSONModel.h"

@interface BZTagModel : JSONModel
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, assign) NSInteger pinCount;
@end
