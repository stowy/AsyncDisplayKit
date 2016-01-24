//
//  LoadingView.h
//  Sample
//
//  Created by Samuel Stow on 1/24/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UICollectionReusableView

+ (CGFloat)desiredHeightForWidth:(CGFloat)width;
+ (NSString *)reuseIdentifier;

@end
