/* This file provided by Facebook is for non-commercial testing and evaluation
 * purposes only.  Facebook reserves all rights not expressly granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ItemView.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemStyles.h"

static const NSString *kItemViewNibName = @"ItemView";

const CGFloat kItemDesignWidth = 320.0;
const CGFloat kItemDesignHeight = 299.0;

@interface ItemView ()

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *firstInfoLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondInfoLabel;
@property (nonatomic, strong) IBOutlet UILabel *badgeView;
@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *finalPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *soldOutLabelFlat;
@property (nonatomic, strong) IBOutlet UIView *soldOutOverlay;

@end

@implementation ItemView


+ (CGFloat)hardcodedPriceBarHeight {
    return 106.0;
}


#pragma mark - view rendering lifecycle

- (instancetype)initWithNib {
  UINib *nib = [UINib nibWithNibName:@"ItemView" bundle:[NSBundle mainBundle]];
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

-(void)awakeFromNib {
  [self setup];
}

+ (BOOL)isRTL {
  return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}


- (void)setup {
  
  self.placeholderImage = [ItemStyles placeholderImage];
  self.imageView.image = self.placeholderImage;

//    // Support RTL
    if ([ItemView isRTL]) {
        self.titleLabel.textAlignment = NSTextAlignmentNatural;
        self.firstInfoLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.secondInfoLabel.textAlignment = NSTextAlignmentRight;
        self.originalPriceLabel.textAlignment = NSTextAlignmentLeft;
        self.finalPriceLabel.textAlignment = NSTextAlignmentLeft;
    }

  self.titleLabel.font = [ItemStyles titleStyle][NSFontAttributeName];
  self.titleLabel.textColor = [ItemStyles titleStyle][NSForegroundColorAttributeName];
  
    UIColor *white = [UIColor whiteColor];

    self.titleLabel.backgroundColor = white;
    self.firstInfoLabel.backgroundColor = white;
    self.secondInfoLabel.backgroundColor = white;
    self.distanceLabel.backgroundColor = white;
    self.originalPriceLabel.backgroundColor = white;
    self.finalPriceLabel.backgroundColor = white;
}

- (void)updateView {

  self.titleLabel.text = self.viewModel.titleText;
  self.firstInfoLabel.text = self.viewModel.firstInfoText;
  self.secondInfoLabel.text = self.viewModel.secondInfoText;
  self.originalPriceLabel.text = self.viewModel.originalPriceText;
  self.finalPriceLabel.text = self.viewModel.finalPriceText;
  self.distanceLabel.text = self.viewModel.distanceLabelText;
  
  if (self.viewModel.badgeText) {
    self.badgeView.text = self.viewModel.badgeText;
  }
  
  self.badgeView.hidden = self.viewModel.badgeText == nil;
  
  // Set Title text
  self.titleLabel.text = self.viewModel.titleText;
  
  if (self.viewModel.firstInfoText) {
    self.firstInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:self.viewModel.firstInfoText attributes:[ItemStyles subtitleStyle]];
  }
  
  if (self.viewModel.secondInfoText) {
    self.secondInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:self.viewModel.secondInfoText attributes:[ItemStyles secondInfoStyle]];
  }
  if (self.viewModel.originalPriceText) {
    self.originalPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.viewModel.originalPriceText attributes:[ItemStyles originalPriceStyle]];
  }
  if (self.viewModel.finalPriceText) {
    self.finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.viewModel.finalPriceText attributes:[ItemStyles finalPriceStyle]];
  }
  if (self.viewModel.distanceLabelText) {
    NSString *format = [ItemView isRTL] ? @"%@ •" : @"• %@";
    NSString *distanceText = [NSString stringWithFormat:format, self.viewModel.distanceLabelText];
    
    self.distanceLabel.attributedText = [[NSAttributedString alloc] initWithString:distanceText attributes:[ItemStyles distanceStyle]];
  }
  
  BOOL hasBadge = self.viewModel.badgeText != nil;
  if (hasBadge) {
    self.badgeView.attributedText = [[NSAttributedString alloc] initWithString:self.viewModel.badgeText attributes:[ItemStyles badgeStyle]];
    self.badgeView.backgroundColor = [ItemStyles badgeColor];
  }
  self.badgeView.hidden = !hasBadge;
  
}


- (void)updateSoldOutState {
    BOOL isSoldOut = self.viewModel.soldOutText != nil;

    if (isSoldOut) {
      NSString *soldOutText = self.viewModel.soldOutText;
      self.soldOutLabelFlat.attributedText = [[NSAttributedString alloc] initWithString:soldOutText attributes:[ItemStyles soldOutStyle]];
    }
    self.soldOutOverlay.hidden = !isSoldOut;
}

#pragma mark - Private methods


- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.viewModel) {
        [self loadImage];
    }
}

- (void)setViewModel:(ItemViewModel *)viewModel {
    if (viewModel == nil) {
        return;
    }

    // Always update the deal. Deals are mutable, so we need to check if any elements where changed, even if its the same object.
    _viewModel = viewModel;

    [self updateView];
    [self updateSoldOutState];
    [self loadImage];
}

- (void)prepareForReuse {
  self.viewModel = nil;
  self.imageView.image = self.placeholderImage;
  self.titleLabel.text = nil;
  self.firstInfoLabel.text = nil;
  self.secondInfoLabel.text = nil;
  self.originalPriceLabel.text = nil;
  self.finalPriceLabel.text = nil;
  self.distanceLabel.text = nil;
}

+ (CGSize)preferredViewSize {
    return CGSizeMake(kItemDesignWidth, kItemDesignHeight);
}

+ (CGSize)sizeForWidth:(CGFloat)width {
  CGFloat height = [self scaledHeightForPreferredSize:[self preferredViewSize] scaledWidth:width];
  return CGSizeMake(width, height);
}


+ (CGFloat)scaledHeightForPreferredSize:(CGSize)preferredSize scaledWidth:(CGFloat)scaledWidth {
    CGFloat scale = scaledWidth / kItemDesignWidth;
    CGFloat hardcodedPriceBarHeight = [ItemView hardcodedPriceBarHeight];
    CGFloat scaledHeight = ceilf(scale * (kItemDesignHeight - hardcodedPriceBarHeight)) + hardcodedPriceBarHeight;

    return scaledHeight;
}


#pragma mark - view operations

- (void)loadImage {
  
  CGSize imageSize = self.imageView.frame.size;
  NSURL *url = [self.viewModel imageURLWithSize:imageSize];
  // TODO: load url.
  if (![self.imageView.sd_imageURL isEqual:url]) {
    [self.imageView sd_setImageWithURL:url placeholderImage:self.placeholderImage];
  }
  
}



@end
