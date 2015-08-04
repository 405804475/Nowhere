//
//  AppDelegate.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "AppDelegate.h"
#import "TWTSideMenuViewController.h"
#import "LeftSideViewController.h"

@interface AppDelegate ()<TWTSideMenuViewControllerDelegate>

@property (nonatomic , retain) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic , retain) LeftSideViewController *leftSideVC;
@property (nonatomic , retain) Reachability *hostReach;

@end

@implementation AppDelegate


#pragma mark - 运行程序的时候先判断网络状态
- (void)reachabityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //appKey
    [UMSocialData setAppKey:@"558f95f66758e24b1005295"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //添加网络监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
    [self.hostReach startNotifier];
    
    
    //根视图控制器
//    _mainVC = [[MainViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
//    self.window.rootViewController = nav;
//    [self.mainVC release];
//    [nav release];
    
    _mainVC = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
    _leftSideVC = [[LeftSideViewController alloc]init];
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc]initWithMenuViewController:self.leftSideVC mainViewController:nav];
#pragma mark - 设置侧边栏弹出范围
    self.sideMenuViewController.edgeOffset = (UIOffset) {.horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 80.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1.0f : 1.0f;
    self.sideMenuViewController.delegate = self;
    self.window.rootViewController = self.sideMenuViewController;
    self.window.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    [self.sideMenuViewController release];
    [self.leftSideVC release];
    [self.mainVC release];
    [nav release];
    
    
#pragma mark - 程序启动图
    UIImageView *chengxuyindaoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    chengxuyindaoView.image = [UIImage imageNamed:@"chengxuyindao.jpg"];
    
    [self.window addSubview:chengxuyindaoView];
    
    // 放到最顶层
    [self.window bringSubviewToFront:chengxuyindaoView];
    
    // 设置动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
    
    chengxuyindaoView.alpha = 0.2;
    chengxuyindaoView.frame = CGRectMake(0, -self.window.frame.size.height, self.window.frame.size.width, self.window.frame.size.height);
    [UIView commitAnimations];
    [chengxuyindaoView release];
    
#pragma mark - 判断程序是否第一次启动
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
    }else{
        NSLog(@"不是第一次启动");
    }
    
    
    
    return YES;
}



-(void)dealloc
{
    [_mainVC release];
    [super dealloc];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
