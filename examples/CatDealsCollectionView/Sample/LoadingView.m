//
//  LoadingView.m
//  Sample
//
//  Created by Samuel Stow on 1/24/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "LoadingView.h"

static CGFloat kFixedHeight = 200.0f;

@implementation LoadingView

+ (CGFloat)desiredHeightForWidth:(CGFloat)width {
  return kFixedHeight;
}

+ (NSString *)reuseIdentifier {
  return @"LoadingView";
}

- (NSString *)reuseIdentifier {
  return [[self class] reuseIdentifier];
}

- (instancetype)initWithNib {
  UINib *nib = [UINib nibWithNibName:@"LoadingView" bundle:[NSBundle mainBundle]];
  self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [self initWithNib];
  if (self) {
    self.frame = frame;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    
  }
  return self;
}

- (instancetype)init {
  return [self initWithNib];
}

-(void)awakeFromNib {
  
}

@end
