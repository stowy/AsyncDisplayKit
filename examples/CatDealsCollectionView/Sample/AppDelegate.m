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

#import "CollectionViewController.h"
#import "ViewController.h"

static const BOOL kUseAutoLayout = YES;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = [[UINavigationController alloc] init];
  
  [self pushNewViewControllerAnimated:NO];
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)pushNewViewControllerAnimated:(BOOL)animated
{
  UINavigationController *navController = (UINavigationController *)self.window.rootViewController;

  UIViewController *viewController = kUseAutoLayout ? [[CollectionViewController alloc] init] : [[ViewController alloc] init];
  viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push Another Copy" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewViewController)];

  [navController pushViewController:viewController animated:animated];
}

- (void)pushNewViewController
{
  [self pushNewViewControllerAnimated:YES];
}

@end
