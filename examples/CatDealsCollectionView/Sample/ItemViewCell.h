//
//  ItemViewCell.h
//  Sample
//
//  Created by Samuel Stow on 1/24/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"

@interface ItemViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) ItemView *itemView;

@end