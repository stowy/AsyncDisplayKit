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

#import "ItemNode.h"
#import "ItemStyles.h"

const CGFloat kFixedLabelsAreaHeight = 96.0;
const CGFloat kDesignWidth = 320.0;
const CGFloat kDesignHeight = 299.0;

@interface ItemNode() <ASNetworkImageNodeDelegate>

@property (nonatomic, strong) ItemViewModel *viewModel;

@property (nonatomic, strong) ASNetworkImageNode *dealImageView;

@property (nonatomic, strong) ASTextNode *titleLabel;
@property (nonatomic, strong) ASTextNode *firstInfoLabel;
@property (nonatomic, strong) ASTextNode *distanceLabel;
@property (nonatomic, strong) ASTextNode *secondInfoLabel;
@property (nonatomic, strong) ASTextNode *originalPriceLabel;
@property (nonatomic, strong) ASTextNode *finalPriceLabel;
@property (nonatomic, strong) ASTextNode *soldOutLabelFlat;
@property (nonatomic, strong) ASDisplayNode *soldOutOverlayTop;
@property (nonatomic, strong) ASDisplayNode *soldOutOverlay;

@end

@implementation ItemNode

- (instancetype)initWithViewModel:(ItemViewModel *)viewModel
{
  self = [super init];
  if (self != nil) {
    _viewModel = viewModel;
    [self setup];
    [self updateLabels];
    [self updateBackgroundColor];
    
  }
  return self;
}

- (void)setup {
  self.dealImageView = [[ASNetworkImageNode alloc] init];
  self.dealImageView.delegate = self;
  self.dealImageView.placeholderEnabled = YES;
  self.dealImageView.placeholderColor = [UIColor grayColor];
  self.dealImageView.placeholderFadeDuration = 0.3;
  
  self.titleLabel = [[ASTextNode alloc] init];
  self.titleLabel.maximumNumberOfLines = 2;
  self.titleLabel.alignSelf = ASStackLayoutAlignSelfStart;
  self.titleLabel.flexGrow = YES;
  
  self.firstInfoLabel = [[ASTextNode alloc] init];
  self.firstInfoLabel.maximumNumberOfLines = 1;
  self.secondInfoLabel = [[ASTextNode alloc] init];
  self.secondInfoLabel.maximumNumberOfLines = 1;
  self.distanceLabel = [[ASTextNode alloc] init];
  self.distanceLabel.maximumNumberOfLines = 1;
  self.originalPriceLabel = [[ASTextNode alloc] init];
  self.originalPriceLabel.maximumNumberOfLines = 1;
  self.finalPriceLabel = [[ASTextNode alloc] init];
  self.finalPriceLabel.maximumNumberOfLines = 1;
  
  self.soldOutLabelFlat = [[ASTextNode alloc] init];
  self.soldOutLabelFlat.alignSelf = ASStackLayoutAlignSelfCenter;
  self.soldOutLabelFlat.flexGrow = YES;
  self.soldOutLabelFlat.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
  self.soldOutLabelFlat.sizeRange = ASRelativeSizeRangeMake(ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(0), ASRelativeDimensionMakeWithPoints(50.0)), ASRelativeSizeMake(ASRelativeDimensionMakeWithPercent(100), ASRelativeDimensionMakeWithPoints(50.0)));
  
  self.soldOutOverlayTop = [[ASDisplayNode alloc] init];
  self.soldOutOverlayTop.flexGrow = YES;
  self.soldOutOverlayTop.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  
  [self addSubnode:self.dealImageView];
  [self addSubnode:self.titleLabel];
  [self addSubnode:self.firstInfoLabel];
  [self addSubnode:self.secondInfoLabel];
  [self addSubnode:self.originalPriceLabel];
  [self addSubnode:self.finalPriceLabel];
  [self addSubnode:self.distanceLabel];
  
  self.soldOutOverlay = [[ASDisplayNode alloc] init];
  self.soldOutOverlay.backgroundColor = [UIColor clearColor];
  [self.soldOutOverlay addSubnode:self.soldOutLabelFlat];
  [self.soldOutOverlay addSubnode:self.soldOutOverlayTop];
  self.soldOutOverlay.hidden = YES;
  [self addSubnode:self.soldOutOverlay];
  
  BOOL isRTL = NO;
  if (isRTL) {
    self.titleLabel.alignSelf = ASStackLayoutAlignSelfEnd;
    self.firstInfoLabel.alignSelf = ASStackLayoutAlignSelfEnd;
    self.distanceLabel.alignSelf = ASStackLayoutAlignSelfEnd;
    self.secondInfoLabel.alignSelf = ASStackLayoutAlignSelfEnd;
    self.originalPriceLabel.alignSelf = ASStackLayoutAlignSelfStart;
    self.finalPriceLabel.alignSelf = ASStackLayoutAlignSelfStart;
  } else {
    self.firstInfoLabel.alignSelf = ASStackLayoutAlignSelfStart;
    self.distanceLabel.alignSelf = ASStackLayoutAlignSelfStart;
    self.secondInfoLabel.alignSelf = ASStackLayoutAlignSelfStart;
    self.originalPriceLabel.alignSelf = ASStackLayoutAlignSelfEnd;
    self.finalPriceLabel.alignSelf = ASStackLayoutAlignSelfEnd;
  }
}

- (void)updateLabels {
  // Set Title text
  if (self.viewModel.titleText) {
    self.titleLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.titleText attributes:[ItemStyles titleStyle]];
  }
  if (self.viewModel.firstInfoText) {
    self.firstInfoLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.firstInfoText attributes:[ItemStyles subtitleStyle]];
  }
  
  if (self.viewModel.secondInfoText) {
    self.secondInfoLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.secondInfoText attributes:[ItemStyles secondInfoStyle]];
  }
  if (self.viewModel.originalPriceText) {
    self.originalPriceLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.originalPriceText attributes:[ItemStyles originalPriceStyle]];
  }
  if (self.viewModel.finalPriceText) {
        self.finalPriceLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.finalPriceText attributes:[ItemStyles finalPriceStyle]];
  }
  if (self.viewModel.distanceLabelText) {
    self.distanceLabel.attributedString = [[NSAttributedString alloc] initWithString:self.viewModel.distanceLabelText attributes:[ItemStyles distanceStyle]];
  }
  
  BOOL isSoldOut = self.viewModel.soldOutText != nil;
  
  if (isSoldOut) {
    NSString *soldOutText = self.viewModel.soldOutText;
    self.soldOutLabelFlat.attributedString = [[NSAttributedString alloc] initWithString:soldOutText attributes:[ItemStyles soldOutStyle]];
  }
  self.soldOutOverlay.hidden = !isSoldOut;
}

- (void)updateBackgroundColor
{
  if (self.highlighted) {
    self.backgroundColor = [UIColor grayColor];
  } else if (self.selected) {
    self.backgroundColor = [UIColor darkGrayColor];
  } else {
    self.backgroundColor = [UIColor whiteColor];
  }
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
  NSLog(@"Image loaded");
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  [self updateBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  [self updateBackgroundColor];
}

#pragma mark - superclass

- (void)displayWillStart {
  [super displayWillStart];
  [self fetchData];
}

- (void)fetchData {
  [super fetchData];
  if (self.viewModel) {
    [self loadImage];
  }
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  CGFloat kInsetHorizontal = 16.0;
  CGFloat kInsetTop = 6.0;
  CGFloat kInsetBottom = 0.0;
  
  UIEdgeInsets textInsets = UIEdgeInsetsMake(kInsetTop, kInsetHorizontal, kInsetBottom, kInsetHorizontal);
  
  ASLayoutSpec *verticalSpacer = [[ASLayoutSpec alloc] init];
  verticalSpacer.flexGrow = YES;
  
  ASLayoutSpec *horizontalSpacer1 = [[ASLayoutSpec alloc] init];
  horizontalSpacer1.flexGrow = YES;
  
  ASLayoutSpec *horizontalSpacer2 = [[ASLayoutSpec alloc] init];
  horizontalSpacer2.flexGrow = YES;
  
  ASStackLayoutSpec *info1Stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[self.firstInfoLabel, self.distanceLabel, horizontalSpacer1, self.originalPriceLabel]];
  
  ASStackLayoutSpec *info2Stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0.0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[self.secondInfoLabel, horizontalSpacer2, self.finalPriceLabel]];
  
  ASStackLayoutSpec *textStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[self.titleLabel, verticalSpacer, info1Stack, info2Stack]];
  
  ASInsetLayoutSpec *textWrapper = [ASInsetLayoutSpec insetLayoutSpecWithInsets:textInsets child:textStack];
  textWrapper.flexGrow = YES;
  
  CGFloat imageRatio = [self imageRatioFromSize:constrainedSize.max];
  
  ASRatioLayoutSpec *imagePlace = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:imageRatio child:self.dealImageView];
  
  ASOverlayLayoutSpec *soldOut = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.soldOutOverlay overlay:self.soldOutOverlayTop];
  soldOut.flexGrow = YES;
  
  ASOverlayLayoutSpec *soldOutOverImage = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imagePlace overlay:soldOut];
  
  NSArray *stackChildren = @[soldOutOverImage, textWrapper];
  
  ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:stackChildren];
  
  return mainStack;
}


+ (CGSize)sizeForWidth:(CGFloat)width {
  CGFloat height = [self scaledHeightForPreferredSize:[self preferredViewSize] scaledWidth:width];
  return CGSizeMake(width, height);
}


+ (CGSize)preferredViewSize {
  return CGSizeMake(kDesignWidth, kDesignHeight);
}

+ (CGFloat)scaledHeightForPreferredSize:(CGSize)preferredSize scaledWidth:(CGFloat)scaledWidth {
  CGFloat scale = scaledWidth / kDesignWidth;
  CGFloat scaledHeight = ceilf(scale * (kDesignHeight - kFixedLabelsAreaHeight)) + kFixedLabelsAreaHeight;
  
  return scaledHeight;
}



#pragma mark - view operations

- (CGFloat)imageRatioFromSize:(CGSize)size {
  CGFloat imageHeight = size.height - kFixedLabelsAreaHeight;
  CGFloat imageRatio = imageHeight / size.width;
  
  return imageRatio;
}

- (CGSize)imageSize {
  if (!CGSizeEqualToSize(self.dealImageView.frame.size, CGSizeZero)) {
    return self.dealImageView.frame.size;
  } else if (!CGSizeEqualToSize(self.calculatedSize, CGSizeZero)) {
    CGFloat imageRatio = [self imageRatioFromSize:self.calculatedSize];
    CGFloat imageWidth = self.calculatedSize.width;
    return CGSizeMake(imageWidth, imageRatio * imageWidth);
  } else {
    return CGSizeZero;
  }
}

- (void)loadImage {
  CGSize imageSize = [self imageSize];
  if (CGSizeEqualToSize(CGSizeZero, imageSize)) {
    NSLog(@"Invalid image size");
    return;
  }
  
  NSURL *url = [self.viewModel imageURLWithSize:imageSize];
  
  // if we're trying to set the deal image to what it already was, skip the work
  if ([[url absoluteString] isEqualToString:[self.dealImageView.URL absoluteString]]) {
    return;
  }
  NSLog(@"Load deal %@", [url absoluteString]);
  
  // Clear the flag that says we've loaded our image
  [self.dealImageView setURL:url];
}

@end
