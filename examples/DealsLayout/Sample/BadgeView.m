//
//  BadgeView.m
//  Sample
//
//  Created by Samuel Stow on 1/6/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView


- (instancetype)init {
  self = [super init];
  if (self) {
    _badgeLabel = [[UILabel alloc] init];
    [self addSubview:_badgeLabel];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"label":_badgeLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"label":_badgeLabel}]];
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGFloat separatorWidth = 8 * 2;
  size.width -= separatorWidth;
  CGSize labelSize = [_badgeLabel sizeThatFits:size];
  labelSize.width += separatorWidth;
  size.width = labelSize.width;
  return size;
}

@end
