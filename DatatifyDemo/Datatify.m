////////////////////////////////////////////
//       Datatify Class
//  Author: Huy Tran
//  Email: kingbazoka@gmail.com
////////////////////////////////////////////

#import "Datatify.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation Datatify
{
    UIView* currentView;
    Reachability* reachability;
    NOTIFY_POSITION notipos;
    int demoType;
    BOOL isUsingCallback;
}

+ (Datatify*) sharedDatatify
{
    static Datatify *sharedDatatify = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatatify = [[self alloc] init];
    });
    return sharedDatatify;
}

- (id)init {
    if (self = [super init]) {
        demoType = 0;
        isUsingCallback = NO;
    }
    return self;
}

- (void)setType:(int)type
{
    demoType = type;
}

- (void) setPosition:(NOTIFY_POSITION)pos
{
    notipos = pos;
}

- (void) show
{
    [self addDatatifyToView:currentView type:demoType];
}

// Pass nil value here if you don't want to show the HUD icon when network changed
- (void) initWithParent:(UIView*)parentView
{
    currentView = parentView;
    notipos = CENTER_CENTER;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
   
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
}

- (void) removeCallback
{
    if (isUsingCallback)
    {
        isUsingCallback = NO;
        callBack = nil;
    }
}

- (void) setCallback:(DatatifyCallback)callback
{
    if (!isUsingCallback)
    {
        isUsingCallback = YES;
        callBack = callback;
    }
}

- (void) addDatatifyToView:(UIView*)view type:(int)type
{
    UIView* vew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 122, 122)];
    [vew setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8]];
    vew.layer.cornerRadius = 10.0f;
    [vew setAlpha:0.0];
    
    switch (notipos) {
        case TOP_LEFT:
            vew.center = CGPointMake(vew.bounds.size.width / 2, vew.bounds.size.height / 2);
            break;
        case TOP_CENTER:
            vew.center = CGPointMake(view.bounds.size.width / 2, vew.bounds.size.height / 2);
            break;
        case TOP_RIGHT:
            vew.center = CGPointMake(view.bounds.size.width - vew.bounds.size.width / 2, vew.bounds.size.height / 2);
            break;
        case CENTER_LEFT:
            vew.center = CGPointMake(vew.bounds.size.width / 2, view.bounds.size.height / 2);
            break;
        case CENTER_CENTER:
            vew.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
            break;
        case CENTER_RIGHT:
            vew.center = CGPointMake(view.bounds.size.width - vew.bounds.size.width / 2, view.bounds.size.height / 2);
            break;
        case BOTTOM_LEFT:
            vew.center = CGPointMake(vew.bounds.size.width / 2, view.bounds.size.height - vew.bounds.size.height / 2);
            break;
        case BOTTOM_CENTER:
            vew.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height - vew.bounds.size.height / 2);
            break;
        case BOTTOM_RIGHT:
            vew.center = CGPointMake(view.bounds.size.width - vew.bounds.size.width / 2, view.bounds.size.height - vew.bounds.size.height / 2);
            break;
        default:
            vew.center = CGPointMake(0, 0);
            break;
    }
    
    [view addSubview:vew];
    
    DrawView* img = [[DrawView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [img setOpaque:NO];
    img.drawBlock = ^(UIView* v,CGContextRef context) {
        if (type == 0)
        {
            [self noIcon];
        }
        if (type == 1)
        {
            [self wifiIcon];
        }
        if (type == 2)
        {
            [self threeGIcon];
        }
    };
    [vew addSubview:img];
    
    [UIView animateWithDuration:0.5 animations:^{
        [vew setAlpha:1.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            [vew setAlpha:0.0];
        } completion:^(BOOL finished) {
            [vew removeFromSuperview];
        }];
    }];
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    int type = 2;
    if          (remoteHostStatus == NotReachable)      {NSLog(@"no"); type = 0; }
    else if     (remoteHostStatus == ReachableViaWiFi)  {NSLog(@"wifi"); type = 1; }
    else if     (remoteHostStatus == ReachableViaWWAN)  {NSLog(@"cell"); type = 2; }
    
    // Only display the indicator if currentView is not null
    if (currentView != nil)
    {
    	[self addDatatifyToView:currentView type:type];
    }
    
    if (isUsingCallback)
    {
        callBack(type);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////  Image Data  //////////

- (void) noIcon
{
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(39,50)];
    [path addLineToPoint: CGPointMake(17,27)];
    [path addLineToPoint: CGPointMake(26,18)];
    [path addLineToPoint: CGPointMake(50,42)];
    [path addLineToPoint: CGPointMake(72,18)];
    [path addLineToPoint: CGPointMake(81,28)];
    [path addLineToPoint: CGPointMake(61,50)];
    [path addLineToPoint: CGPointMake(61,50)];
    [path addLineToPoint: CGPointMake(81,70)];
    [path addLineToPoint: CGPointMake(72,81)];
    [path addLineToPoint: CGPointMake(50,57)];
    [path addLineToPoint: CGPointMake(26,81)];
    [path addLineToPoint: CGPointMake(17,72)];
    [path addLineToPoint: CGPointMake(39,50)];
    [fillColor setFill];
    [path fill];
    [strokeColor setStroke];
    path.lineWidth = 0.25;
    [path stroke];
}

- (void) threeGIcon
{
    UIColor* fillColor = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(89,30)];
    [path addCurveToPoint: CGPointMake(77,29) controlPoint1: CGPointMake(85,28) controlPoint2: CGPointMake(81,28)];
    [path addCurveToPoint: CGPointMake(67,38) controlPoint1: CGPointMake(72,30) controlPoint2: CGPointMake(69,34)];
    [path addCurveToPoint: CGPointMake(65,51) controlPoint1: CGPointMake(66,42) controlPoint2: CGPointMake(65,46)];
    [path addCurveToPoint: CGPointMake(66,65) controlPoint1: CGPointMake(65,56) controlPoint2: CGPointMake(65,60)];
    [path addCurveToPoint: CGPointMake(71,73) controlPoint1: CGPointMake(67,68) controlPoint2: CGPointMake(69,71)];
    [path addCurveToPoint: CGPointMake(79,76) controlPoint1: CGPointMake(73,75) controlPoint2: CGPointMake(76,76)];
    [path addCurveToPoint: CGPointMake(80,75) controlPoint1: CGPointMake(80,76) controlPoint2: CGPointMake(80,75)];
    [path addCurveToPoint: CGPointMake(80,59) controlPoint1: CGPointMake(80,70) controlPoint2: CGPointMake(80,64)];
    [path addLineToPoint: CGPointMake(80,59)];
    [path addCurveToPoint: CGPointMake(74,59) controlPoint1: CGPointMake(78,59) controlPoint2: CGPointMake(76,59)];
    [path addCurveToPoint: CGPointMake(74,48) controlPoint1: CGPointMake(74,55) controlPoint2: CGPointMake(74,51)];
    [path addCurveToPoint: CGPointMake(93,48) controlPoint1: CGPointMake(80,48) controlPoint2: CGPointMake(86,48)];
    [path addLineToPoint: CGPointMake(93,48)];
    [path addCurveToPoint: CGPointMake(93,84) controlPoint1: CGPointMake(93,60) controlPoint2: CGPointMake(93,72)];
    [path addCurveToPoint: CGPointMake(92,85) controlPoint1: CGPointMake(93,84) controlPoint2: CGPointMake(93,85)];
    [path addCurveToPoint: CGPointMake(69,86) controlPoint1: CGPointMake(85,87) controlPoint2: CGPointMake(77,88)];
    [path addCurveToPoint: CGPointMake(54,72) controlPoint1: CGPointMake(62,84) controlPoint2: CGPointMake(57,79)];
    [path addCurveToPoint: CGPointMake(51,58) controlPoint1: CGPointMake(52,68) controlPoint2: CGPointMake(51,63)];
    [path addCurveToPoint: CGPointMake(52,44) controlPoint1: CGPointMake(51,53) controlPoint2: CGPointMake(51,48)];
    [path addCurveToPoint: CGPointMake(61,24) controlPoint1: CGPointMake(53,36) controlPoint2: CGPointMake(55,30)];
    [path addCurveToPoint: CGPointMake(77,17) controlPoint1: CGPointMake(65,20) controlPoint2: CGPointMake(71,17)];
    [path addCurveToPoint: CGPointMake(90,18) controlPoint1: CGPointMake(82,16) controlPoint2: CGPointMake(86,17)];
    [path addCurveToPoint: CGPointMake(91,20) controlPoint1: CGPointMake(92,18) controlPoint2: CGPointMake(92,18)];
    [path addCurveToPoint: CGPointMake(89,30) controlPoint1: CGPointMake(91,23) controlPoint2: CGPointMake(90,27)];
    [fillColor setFill];
    [path fill];
    
    UIColor* fillColor1 = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint: CGPointMake(9,74)];
    [path1 addCurveToPoint: CGPointMake(18,76) controlPoint1: CGPointMake(12,75) controlPoint2: CGPointMake(15,76)];
    [path1 addCurveToPoint: CGPointMake(29,69) controlPoint1: CGPointMake(23,76) controlPoint2: CGPointMake(28,74)];
    [path1 addCurveToPoint: CGPointMake(20,56) controlPoint1: CGPointMake(30,63) controlPoint2: CGPointMake(27,58)];
    [path1 addCurveToPoint: CGPointMake(15,56) controlPoint1: CGPointMake(18,56) controlPoint2: CGPointMake(17,56)];
    [path1 addCurveToPoint: CGPointMake(15,46) controlPoint1: CGPointMake(15,53) controlPoint2: CGPointMake(15,50)];
    [path1 addCurveToPoint: CGPointMake(18,46) controlPoint1: CGPointMake(16,46) controlPoint2: CGPointMake(17,46)];
    [path1 addCurveToPoint: CGPointMake(24,44) controlPoint1: CGPointMake(20,46) controlPoint2: CGPointMake(22,45)];
    [path1 addCurveToPoint: CGPointMake(27,35) controlPoint1: CGPointMake(27,42) controlPoint2: CGPointMake(28,38)];
    [path1 addCurveToPoint: CGPointMake(21,30) controlPoint1: CGPointMake(26,32) controlPoint2: CGPointMake(24,30)];
    [path1 addCurveToPoint: CGPointMake(12,32) controlPoint1: CGPointMake(17,29) controlPoint2: CGPointMake(15,30)];
    [path1 addLineToPoint: CGPointMake(11,32)];
    [path1 addCurveToPoint: CGPointMake(9,23) controlPoint1: CGPointMake(10,29) controlPoint2: CGPointMake(10,26)];
    [path1 addCurveToPoint: CGPointMake(10,22) controlPoint1: CGPointMake(9,22) controlPoint2: CGPointMake(9,22)];
    [path1 addCurveToPoint: CGPointMake(18,19) controlPoint1: CGPointMake(12,20) controlPoint2: CGPointMake(15,20)];
    [path1 addCurveToPoint: CGPointMake(29,20) controlPoint1: CGPointMake(22,18) controlPoint2: CGPointMake(26,18)];
    [path1 addCurveToPoint: CGPointMake(41,35) controlPoint1: CGPointMake(36,22) controlPoint2: CGPointMake(41,27)];
    [path1 addCurveToPoint: CGPointMake(31,50) controlPoint1: CGPointMake(41,41) controlPoint2: CGPointMake(37,46)];
    [path1 addLineToPoint: CGPointMake(31,50)];
    [path1 addLineToPoint: CGPointMake(31,50)];
    [path1 addCurveToPoint: CGPointMake(34,51) controlPoint1: CGPointMake(32,50) controlPoint2: CGPointMake(33,51)];
    [path1 addCurveToPoint: CGPointMake(42,64) controlPoint1: CGPointMake(39,54) controlPoint2: CGPointMake(41,58)];
    [path1 addCurveToPoint: CGPointMake(38,80) controlPoint1: CGPointMake(43,70) controlPoint2: CGPointMake(42,75)];
    [path1 addCurveToPoint: CGPointMake(26,87) controlPoint1: CGPointMake(35,83) controlPoint2: CGPointMake(31,86)];
    [path1 addCurveToPoint: CGPointMake(8,85) controlPoint1: CGPointMake(20,88) controlPoint2: CGPointMake(14,87)];
    [path1 addCurveToPoint: CGPointMake(7,83) controlPoint1: CGPointMake(7,85) controlPoint2: CGPointMake(7,84)];
    [path1 addCurveToPoint: CGPointMake(9,74) controlPoint1: CGPointMake(8,80) controlPoint2: CGPointMake(8,77)];
    [path1 addLineToPoint: CGPointMake(9,74)];
    [fillColor1 setFill];
    [path1 fill];
}

- (void) wifiIcon
{
    UIColor* fillColor = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(50,20)];
    [path addCurveToPoint: CGPointMake(84,33) controlPoint1: CGPointMake(63,20) controlPoint2: CGPointMake(74,24)];
    [path addCurveToPoint: CGPointMake(85,40) controlPoint1: CGPointMake(87,35) controlPoint2: CGPointMake(87,38)];
    [path addCurveToPoint: CGPointMake(78,40) controlPoint1: CGPointMake(84,42) controlPoint2: CGPointMake(81,42)];
    [path addCurveToPoint: CGPointMake(21,40) controlPoint1: CGPointMake(60,25) controlPoint2: CGPointMake(39,25)];
    [path addCurveToPoint: CGPointMake(14,40) controlPoint1: CGPointMake(18,42) controlPoint2: CGPointMake(16,42)];
    [path addCurveToPoint: CGPointMake(15,33) controlPoint1: CGPointMake(12,38) controlPoint2: CGPointMake(12,36)];
    [path addCurveToPoint: CGPointMake(50,20) controlPoint1: CGPointMake(25,24) controlPoint2: CGPointMake(37,20)];
    [fillColor setFill];
    [path fill];
    
    UIColor* fillColor1 = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint: CGPointMake(49,35)];
    [path1 addCurveToPoint: CGPointMake(73,44) controlPoint1: CGPointMake(59,35) controlPoint2: CGPointMake(66,38)];
    [path1 addCurveToPoint: CGPointMake(75,51) controlPoint1: CGPointMake(76,47) controlPoint2: CGPointMake(77,49)];
    [path1 addCurveToPoint: CGPointMake(67,51) controlPoint1: CGPointMake(73,54) controlPoint2: CGPointMake(71,53)];
    [path1 addCurveToPoint: CGPointMake(53,44) controlPoint1: CGPointMake(63,47) controlPoint2: CGPointMake(59,45)];
    [path1 addCurveToPoint: CGPointMake(33,49) controlPoint1: CGPointMake(46,43) controlPoint2: CGPointMake(39,45)];
    [path1 addCurveToPoint: CGPointMake(31,51) controlPoint1: CGPointMake(32,50) controlPoint2: CGPointMake(31,51)];
    [path1 addCurveToPoint: CGPointMake(24,51) controlPoint1: CGPointMake(28,53) controlPoint2: CGPointMake(25,53)];
    [path1 addCurveToPoint: CGPointMake(25,45) controlPoint1: CGPointMake(22,49) controlPoint2: CGPointMake(22,47)];
    [path1 addCurveToPoint: CGPointMake(39,37) controlPoint1: CGPointMake(29,42) controlPoint2: CGPointMake(34,39)];
    [path1 addCurveToPoint: CGPointMake(49,35) controlPoint1: CGPointMake(42,35) controlPoint2: CGPointMake(46,35)];
    [fillColor1 setFill];
    [path1 fill];
    
    UIColor* fillColor2 = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint: CGPointMake(49,50)];
    [path2 addCurveToPoint: CGPointMake(64,56) controlPoint1: CGPointMake(55,50) controlPoint2: CGPointMake(60,52)];
    [path2 addCurveToPoint: CGPointMake(65,63) controlPoint1: CGPointMake(66,58) controlPoint2: CGPointMake(67,61)];
    [path2 addCurveToPoint: CGPointMake(59,63) controlPoint1: CGPointMake(63,65) controlPoint2: CGPointMake(61,65)];
    [path2 addCurveToPoint: CGPointMake(40,63) controlPoint1: CGPointMake(51,58) controlPoint2: CGPointMake(48,58)];
    [path2 addCurveToPoint: CGPointMake(34,63) controlPoint1: CGPointMake(38,65) controlPoint2: CGPointMake(36,65)];
    [path2 addCurveToPoint: CGPointMake(34,57) controlPoint1: CGPointMake(32,61) controlPoint2: CGPointMake(32,59)];
    [path2 addCurveToPoint: CGPointMake(49,50) controlPoint1: CGPointMake(38,52) controlPoint2: CGPointMake(44,50)];
    [fillColor2 setFill];
    [path2 fill];
    
    UIColor* fillColor3 = [UIColor colorWithRed: 0.996 green: 0.996 blue: 0.996 alpha: 1];
    UIBezierPath* path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint: CGPointMake(55,71)];
    [path3 addCurveToPoint: CGPointMake(50,76) controlPoint1: CGPointMake(55,74) controlPoint2: CGPointMake(52,76)];
    [path3 addCurveToPoint: CGPointMake(44,71) controlPoint1: CGPointMake(47,76) controlPoint2: CGPointMake(44,74)];
    [path3 addCurveToPoint: CGPointMake(50,66) controlPoint1: CGPointMake(44,68) controlPoint2: CGPointMake(47,66)];
    [path3 addCurveToPoint: CGPointMake(55,71) controlPoint1: CGPointMake(53,66) controlPoint2: CGPointMake(55,68)];
    [fillColor3 setFill];
    [path3 fill];
}

@end

/////////////////////////////////////////////////////////////////
//              DRAW VIEW CLASS
////////////////////////////////////////////////////////////////

@implementation DrawView

@synthesize drawBlock;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.drawBlock)
        self.drawBlock(self,context);
}

@end

//////////////////////////////////////////////////////////////
//          REACHABILITY CLASS
//////////////////////////////////////////////////////////////

/*
 Copyright (c) 2011, Tony Million.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

NSString *const kReachabilityChangedNotification = @"kReachabilityChangedNotification";

@interface Reachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;


#if NEEDS_DISPATCH_RETAIN_RELEASE
@property (nonatomic, assign) dispatch_queue_t          reachabilitySerialQueue;
#else
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
#endif


@property (nonatomic, strong) id reachabilityObject;

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end

static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags)
{
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if	TARGET_OS_IPHONE
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
#else
            'X',
#endif
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
}

// Start listening for reachability notifications on the current run loop
static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target)
#if __has_feature(objc_arc)
    Reachability *reachability = ((__bridge Reachability*)info);
#else
    Reachability *reachability = ((Reachability*)info);
#endif
    
    // We probably don't need an autoreleasepool here, as GCD docs state each queue has its own autorelease pool,
    // but what the heck eh?
    @autoreleasepool
    {
        [reachability reachabilityChanged:flags];
    }
}


@implementation Reachability

@synthesize reachabilityRef;
@synthesize reachabilitySerialQueue;

@synthesize reachableOnWWAN;

@synthesize reachableBlock;
@synthesize unreachableBlock;

@synthesize reachabilityObject;

#pragma mark - Class Constructor Methods

+(Reachability*)reachabilityWithHostName:(NSString*)hostname
{
    return [Reachability reachabilityWithHostname:hostname];
}

+(Reachability*)reachabilityWithHostname:(NSString*)hostname
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];
        
#if __has_feature(objc_arc)
        return reachability;
#else
        return [reachability autorelease];
#endif
        
    }
    
    return nil;
}

+(Reachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];
        
#if __has_feature(objc_arc)
        return reachability;
#else
        return [reachability autorelease];
#endif
    }
    
    return nil;
}

+(Reachability *)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress:&zeroAddress];
}

+(Reachability*)reachabilityForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len            = sizeof(localWifiAddress);
    localWifiAddress.sin_family         = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr    = htonl(IN_LINKLOCALNETNUM);
    
    return [self reachabilityWithAddress:&localWifiAddress];
}


// Initialization methods

-(Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref
{
    self = [super init];
    if (self != nil)
    {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;
    }
    
    return self;
}

-(void)dealloc
{
    [self stopNotifier];
    
    if(self.reachabilityRef)
    {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }
    
	self.reachableBlock		= nil;
	self.unreachableBlock	= nil;
    
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
    
    
}

#pragma mark - Notifier Methods

// Notifier
// NOTE: This uses GCD to trigger the blocks - they *WILL NOT* be called on THE MAIN THREAD
// - In other words DO NOT DO ANY UI UPDATES IN THE BLOCKS.
//   INSTEAD USE dispatch_async(dispatch_get_main_queue(), ^{UISTUFF}) (or dispatch_sync if you want)

-(BOOL)startNotifier
{
    SCNetworkReachabilityContext    context = { 0, NULL, NULL, NULL, NULL };
    
    // this should do a retain on ourself, so as long as we're in notifier mode we shouldn't disappear out from under ourselves
    // woah
    self.reachabilityObject = self;
    
    
    
    // First, we need to create a serial queue.
    // We allocate this once for the lifetime of the notifier.
    self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    if(!self.reachabilitySerialQueue)
    {
        return NO;
    }
    
#if __has_feature(objc_arc)
    context.info = (__bridge void *)self;
#else
    context.info = (void *)self;
#endif
    
    if (!SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context))
    {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
#endif
        
        // Clear out the dispatch queue
        if(self.reachabilitySerialQueue)
        {
#if NEEDS_DISPATCH_RETAIN_RELEASE
            dispatch_release(self.reachabilitySerialQueue);
#endif
            self.reachabilitySerialQueue = nil;
        }
        
        self.reachabilityObject = nil;
        
        return NO;
    }
    
    // Set it as our reachability queue, which will retain the queue
    if(!SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue))
    {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif
        
        // UH OH - FAILURE!
        
        // First stop, any callbacks!
        SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        
        // Then clear out the dispatch queue.
        if(self.reachabilitySerialQueue)
        {
#if NEEDS_DISPATCH_RETAIN_RELEASE
            dispatch_release(self.reachabilitySerialQueue);
#endif
            self.reachabilitySerialQueue = nil;
        }
        
        self.reachabilityObject = nil;
        
        return NO;
    }
    
    return YES;
}

-(void)stopNotifier
{
    // First stop, any callbacks!
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    
    // Unregister target from the GCD serial dispatch queue.
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);
    
    if(self.reachabilitySerialQueue)
    {
#if NEEDS_DISPATCH_RETAIN_RELEASE
        dispatch_release(self.reachabilitySerialQueue);
#endif
        self.reachabilitySerialQueue = nil;
    }
    
    self.reachabilityObject = nil;
}

#pragma mark - reachability tests

// This is for the case where you flick the airplane mode;
// you end up getting something like this:
//Reachability: WR ct-----
//Reachability: -- -------
//Reachability: WR ct-----
//Reachability: -- -------
// We treat this as 4 UNREACHABLE triggers - really apple should do better than this

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags
{
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if	TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN)
    {
        // We're on 3G.
        if(!self.reachableOnWWAN)
        {
            // We don't want to connect when on 3G.
            connectionUP = NO;
        }
    }
#endif
    
    return connectionUP;
}

-(BOOL)isReachable
{
    SCNetworkReachabilityFlags flags;
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self isReachableWithFlags:flags];
}

-(BOOL)isReachableViaWWAN
{
#if	TARGET_OS_IPHONE
    
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        // Check we're REACHABLE
        if(flags & kSCNetworkReachabilityFlagsReachable)
        {
            // Now, check we're on WWAN
            if(flags & kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
#endif
    
    return NO;
}

-(BOOL)isReachableViaWiFi
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        // Check we're reachable
        if((flags & kSCNetworkReachabilityFlagsReachable))
        {
#if	TARGET_OS_IPHONE
            // Check we're NOT on WWAN
            if((flags & kSCNetworkReachabilityFlagsIsWWAN))
            {
                return NO;
            }
#endif
            return YES;
        }
    }
    
    return NO;
}


// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired
{
    return [self connectionRequired];
}

-(BOOL)connectionRequired
{
    SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
    
    return NO;
}

// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand
{
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
	}
	
	return NO;
}

// Is user intervention required?
-(BOOL)isInterventionRequired
{
    SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
	}
	
	return NO;
}


#pragma mark - reachability status stuff

-(NetworkStatus)currentReachabilityStatus
{
    if([self isReachable])
    {
        if([self isReachableViaWiFi])
            return ReachableViaWiFi;
        
#if	TARGET_OS_IPHONE
        return ReachableViaWWAN;
#endif
    }
    
    return NotReachable;
}

-(SCNetworkReachabilityFlags)reachabilityFlags
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        return flags;
    }
    
    return 0;
}

-(NSString*)currentReachabilityString
{
	NetworkStatus temp = [self currentReachabilityStatus];
	
	if(temp == reachableOnWWAN)
	{
        // Updated for the fact that we have CDMA phones now!
		return NSLocalizedString(@"Cellular", @"");
	}
	if (temp == ReachableViaWiFi)
	{
		return NSLocalizedString(@"WiFi", @"");
	}
	
	return NSLocalizedString(@"No Connection", @"");
}

-(NSString*)currentReachabilityFlags
{
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark - Callback function calls this method

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags
{
    if([self isReachableWithFlags:flags])
    {
        if(self.reachableBlock)
        {
            self.reachableBlock(self);
        }
    }
    else
    {
        if(self.unreachableBlock)
        {
            self.unreachableBlock(self);
        }
    }
    
    // this makes sure the change notification happens on the MAIN THREAD
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil userInfo:nil];
    });
}

#pragma mark - Debug Description

- (NSString *) description;
{
    NSString *description = [NSString stringWithFormat:@"<%@: %#x>",
                             NSStringFromClass([self class]), (unsigned int) self];
    return description;
}

@end
