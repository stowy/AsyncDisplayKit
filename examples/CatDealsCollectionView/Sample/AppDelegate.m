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

#import "AppDelegate.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Beta.h>
#import "CollectionViewController.h"
#import "ViewController.h"
#import "ItemStyles.h"

@interface AppDelegate()

@property (nonatomic, strong) UINavigationController *leftNav;
@property (nonatomic, strong) UINavigationController *rightNav;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
  [ASDisplayNode setShouldUseNewRenderingRange:YES];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.leftNav = [[UINavigationController alloc] init];
  self.rightNav = [[UINavigationController alloc] init];
  
  
  self.leftNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ASDK" image:nil tag:0];
  self.rightNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UIKit" image:nil tag:0];
  
  self.window.rootViewController = [[UITabBarController alloc] init];
  [(UITabBarController *)self.window.rootViewController setViewControllers:@[self.leftNav, self.rightNav]];
  
  [self pushNewViewControllerAnimated:NO];
  [self pushNewUIKitViewControllerAnimated:NO];
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)pushNewViewControllerAnimated:(BOOL)animated
{
  UIViewController *viewController = [[ViewController alloc] init];
  UIBarButtonItem *asdkPush = [[UIBarButtonItem alloc] initWithTitle:@"Push ASDK" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewViewController)];
  
  viewController.navigationItem.rightBarButtonItems = @[asdkPush];
  [self.leftNav pushViewController:viewController animated:animated];
}

- (void)pushNewUIKitViewControllerAnimated:(BOOL)animated
{
  UIViewController *viewController = [[CollectionViewController alloc] init];
  UIBarButtonItem *uiKitPush = [[UIBarButtonItem alloc] initWithTitle:@"Push UIKit" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewUIKitViewController)];
  
  viewController.navigationItem.rightBarButtonItems = @[uiKitPush];
  [self.rightNav pushViewController:viewController animated:animated];
}

- (void)pushNewViewController
{
  [self pushNewViewControllerAnimated:YES];
}

- (void)pushNewUIKitViewController
{
  [self pushNewUIKitViewControllerAnimated:YES];
}



@end
