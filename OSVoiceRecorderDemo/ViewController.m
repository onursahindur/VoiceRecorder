//
//  ViewController.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "ViewController.h"
#import "OSVoiceRecorder.h"

@interface ViewController ()

@property(nonatomic, strong) OSVoiceRecorder *recorder;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.recorder = [[OSVoiceRecorder alloc] initDefault];
    OSVoiceRecorderView *recorderView = [self. recorder addRecordViewToView:self.view
                                                            withFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0f)
                                                   withViewController:self];
    recorderView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    recorderView.layer.cornerRadius = 25;
    recorderView.layer.masksToBounds = YES;
}


@end
