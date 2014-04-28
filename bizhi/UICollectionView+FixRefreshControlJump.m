//
//  UICollectionView+FixRefreshControlJump.m
//  LilyCommon
//
//  Created by Limboy on 4/6/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "UICollectionView+FixRefreshControlJump.h"
#import <objc/runtime.h>

@implementation UICollectionView (FixRefreshControlJump)

+ (void)load
{
    Method originMethod = class_getInstanceMethod([UICollectionView class], @selector(setContentInset:));
    Method newMethod = class_getInstanceMethod([UICollectionView class], @selector(setNewContentInset:));
    method_exchangeImplementations(originMethod, newMethod);
}

- (void)setNewContentInset:(UIEdgeInsets)contentInset
{
    if (self.tracking) {
        CGFloat diff = contentInset.top - self.contentInset.top;
        CGPoint translation = [self.panGestureRecognizer translationInView:self];
        translation.y -= diff * 3.0 / 2.0;
        [self.panGestureRecognizer setTranslation:translation inView:self];
    }
    if ([self respondsToSelector:@selector(setNewContentInset:)]) {
        [self setNewContentInset:contentInset];
    }
}

@end
