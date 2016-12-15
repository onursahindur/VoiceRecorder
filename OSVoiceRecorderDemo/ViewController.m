//
//  ViewController.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LayoutConstraints.h"
#import "OSAudioView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    OSAudioView *audioToolbox = [[OSAudioView alloc] initWithFrame:CGRectZero
                                              parentViewController:self];
    audioToolbox.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:audioToolbox];
    audioToolbox.translatesAutoresizingMaskIntoConstraints = NO;
    [audioToolbox distanceLeftToSuperview:0.0f];
    [audioToolbox distanceTopToSuperview:100.0f];
    [audioToolbox setWidthConstraint:CGRectGetWidth(self.view.frame)];
    [audioToolbox setHeightConstraint:800.0f];
    
}

@end
