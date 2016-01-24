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

@property (nonatomic, strong) id imageDownloadIdentifier;
@property (nonatomic, strong) NSURL *currentImageURL;

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

- (void)setup {


  self.placeholderImage = nil;
    [self.imageView setImage:self.placeholderImage];


    // Title Label

//    [self.titleLabel setFont:[fonts titleFont]];

//
//    // First Subtitle
//    [self.firstInfoLabel setFont:[fonts infoFont]];

//
//    // Distance Label
//    [self.distanceLabel setFont:[fonts infoFont]];

//
//    // Second Subtitle
//    [self.secondInfoLabel setFont:[fonts infoFont]];

//
//    // Original price
//    [self.originalPriceLabel setFont:[fonts originalPriceFont:nil]];

//
//    // Discounted / Claimable price label
//    [self.finalPriceLabel setFont:[fonts finalPriceFont:nil]];
//
//    // Setup Sold Out Label
//    self.soldOutLabelFlat.font = [fonts soldOutFont];
//
//    // Support RTL
//    if ([CountryManager sharedInstance].isRTL) {
//        self.titleLabel.textAlignment = NSTextAlignmentNatural;
//        self.firstInfoLabel.textAlignment = NSTextAlignmentRight;
//        self.distanceLabel.textAlignment = NSTextAlignmentRight;
//        self.secondInfoLabel.textAlignment = NSTextAlignmentRight;
//        self.originalPriceLabel.textAlignment = NSTextAlignmentLeft;
//        self.finalPriceLabel.textAlignment = NSTextAlignmentLeft;
//    }

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
  
}


- (void)updateSoldOutState {
    BOOL isSoldOut = self.viewModel.soldOutText != nil;

    if (isSoldOut) {
        self.soldOutLabelFlat.text = self.viewModel.soldOutText;
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
  if (self.imageDownloadIdentifier) {
    [[ASBasicImageDownloader sharedImageDownloader] cancelImageDownloadForIdentifier:self.imageDownloadIdentifier];
  }
  self.imageDownloadIdentifier = nil;
  self.currentImageURL = nil;
  self.imageView.image = nil;
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
  if (![self.currentImageURL isEqual:url]) {
    if (self.imageDownloadIdentifier) {
      [[ASBasicImageDownloader sharedImageDownloader] cancelImageDownloadForIdentifier:self.imageDownloadIdentifier];
    }
    self.currentImageURL = url;
    self.imageDownloadIdentifier = [[ASBasicImageDownloader sharedImageDownloader] downloadImageWithURL:url callbackQueue:dispatch_get_main_queue() downloadProgressBlock:nil completion:^(CGImageRef  _Nullable image, NSError * _Nullable error) {
      UIImage *myImage = [UIImage imageWithCGImage:image];
      self.imageView.image = myImage;
    }];
  }
  
}



@end
