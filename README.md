Datatify
========

Simple single class used to display network status change notification (using Tony Million's Reachability) with callback function.

![alt tag](http://i189.photobucket.com/albums/z94/huydotnet/screenshot_zpsf96fa29c.png)

- Easy to integrate
- Easy to customize
- Easy to use in any project

Installation
===========
The installation is very simple, just few steps:

1. Drag and drop *Datatify.h* and *Datatify.m* into your project
2. Import *SystemConfiguration.framework* (required for Reachability) to your project in **Build Phase** -> **Link Binary with Libraries**
3. Done

How to use
==========
After installed the library, you can start using it.

Firstly, import the library:
```objc
#import "Datatify.h"
```

In any View Controller you need to show the notification. Put this line of code in **viewDidLoad** method:
```objc
- (void)viewDidLoad
{
    [super viewDidLoad];
    ...
    // Initialize the Datatify
    [[Datatify sharedDatatify] initWithParent:self.view];
    ...
}
```

If you want to catch the network connection status change event, just add a callback (by using Block or a separated method)
```objc
[[Datatify sharedDatatify] setCallback:^(int net){
    NSLog(@"Call back %d",net);
}];
```

If you want to change the notification display position, use the **setPosition** function
```objc
[[Datatify sharedDatatify] setPosition:TOP_RIGHT];
```
There are 9 types of positions:
* TOP_LEFT 
* TOP_RIGHT
* TOP_CENTER
* CENTER_LEFT
* CENTER_RIGHT
* CENTER_CENTER
* BOTTOM_LEFT
* BOTTOM_RIGHT
* BOTTOM_CENTER

Customize
=========
It's easy to customize the library. 

### Display effect
If you want to change the notification display effect. you can edit from the line 142 in *Datatify.m*
For example, this code will fade in the notification, then wait for 0.5s before fade out and remove it from parent view
```objc
[UIView animateWithDuration:0.5 animations:^{
    [vew setAlpha:1.0]; // Fade in the notification
} completion:^(BOOL finished) {
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [vew setAlpha:0.0]; // Then fade out, after 0.5s delay
    } completion:^(BOOL finished) {
        [vew removeFromSuperview]; // On fade out completed, remove the notification
    }];
}];
```
You can replace this by flip or slide animation if you want.

### Notification icon
In this library, you can see that I don't use any image file but drawing vector graphic. 
There are 3 function in *Datatify.m* file, beginning at line 173, the *Image Data* section: **noIcon**, **threeGIcon** and **wifiIcon**
I converted the icon in Adobe Illustrator to Objective-C by using [Drawscri.pt](http://drawscri.pt/), it's really cool plugin you must try.
You can change another icon if you don't like my own one.

---

Feel free to use Datatify for any purpose or develop it. Don't forget to share us your result.

For any bug report, contact me via Email or Skype.

**Email:** kingbazoka@gmail.com
**Skype:** huydotnet

Happy coding :)
