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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemViewModel : NSObject

+ (instancetype)randomItem;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *firstInfoText;
@property (nonatomic, copy) NSString *secondInfoText;
@property (nonatomic, copy) NSString *originalPriceText;
@property (nonatomic, copy) NSString *finalPriceText;
@property (nonatomic, copy) NSString *soldOutText;
@property (nonatomic, copy) NSString *distanceLabelText;
@property (nonatomic, copy) NSString *badgeText;

- (NSURL *)imageURLWithSize:(CGSize)size;

@end
