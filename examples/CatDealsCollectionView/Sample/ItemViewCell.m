//
//  ItemViewCell.m
//  Sample
//
//  Created by Samuel Stow on 1/24/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ItemViewCell.h"

@interface ItemViewCell()

@end

@implementation ItemViewCell


- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor lightGrayColor];
    _itemView = [[ItemView alloc] initWithFrame:self.contentView.bounds];
    _itemView.translatesAutoresizingMaskIntoConstraints = YES;
    _itemView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:_itemView];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.itemView prepareForReuse];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
  return targetSize;
}

@end
