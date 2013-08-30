//
//  ViewController.m
//  DatatifyDemo
//
//  Created by Huy Tran on 8/30/13.
//  Copyright (c) 2013 Huy Tran. All rights reserved.
//

#import "ViewController.h"
#import "Datatify.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[Datatify sharedDatatify] initWithParent:self.view];
    
    [[Datatify sharedDatatify] setCallback:^(int net){
        NSLog(@"Call back %d",net);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSString* txt = [btn titleLabel].text;
    if ([txt isEqualToString:@"TL"])
    {
        [[Datatify sharedDatatify] setPosition:TOP_LEFT];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"TC"])
    {
        [[Datatify sharedDatatify] setPosition:TOP_CENTER];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"TR"])
    {
        [[Datatify sharedDatatify] setPosition:TOP_RIGHT];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"CL"])
    {
        [[Datatify sharedDatatify] setPosition:CENTER_LEFT];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"CC"])
    {
        [[Datatify sharedDatatify] setPosition:CENTER_CENTER];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"CR"])
    {
        [[Datatify sharedDatatify] setPosition:CENTER_RIGHT];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"BL"])
    {
        [[Datatify sharedDatatify] setPosition:BOTTOM_LEFT];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"BC"])
    {
        [[Datatify sharedDatatify] setPosition:BOTTOM_CENTER];
        [[Datatify sharedDatatify] show];
    }
    if ([txt isEqualToString:@"BR"])
    {
        [[Datatify sharedDatatify] setPosition:BOTTOM_RIGHT];
        [[Datatify sharedDatatify] show];
    }
}

- (IBAction)buttonTypeClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSString* txt = [btn titleLabel].text;
    
    if ([txt isEqualToString:@"NO"])
    {
        [[Datatify sharedDatatify] setType:0];
    }
    if ([txt isEqualToString:@"WIFI"])
    {
        [[Datatify sharedDatatify] setType:1];
    }
    if ([txt isEqualToString:@"3G"])
    {
        [[Datatify sharedDatatify] setType:2];
    }
}

@end
