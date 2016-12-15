//
//  OSAudioView.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioView.h"
#import "UIView+LayoutConstraints.h"
#import "OSAudioManager.h"

@interface OSAudioView () <OSAudioRecorderViewDelegate, OSAudioPlayerViewDelegate>

@end

@implementation OSAudioView

- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _parentViewController = parentViewController;
        [self initSubViews];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)initSubViews
{
    self.recordURLsArray = [NSMutableArray new];
    
    self.recorderView = [OSAudioRecorderView new];
    self.recorderView.delegate = self;
    self.recorderView.recordNumber = 0;
    [self addSubview:self.recorderView];
    
    self.playerView = [OSAudioPlayerView new];
    self.playerView.backgroundColor = [UIColor redColor];
    self.playerView.delegate = self;
    [self addSubview:self.playerView];
    
}

- (void)addLayoutConstraints
{
    self.recorderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recorderView distanceTopToSuperview:0.0f];
    [self.recorderView distanceLeftToSuperview:0.0f];
    [self.recorderView distanceRightToSuperview:0.0f];
    [self.recorderView setHeightConstraint:50.0f];
    
    self.playerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playerView distance:10.0f toTopView:self.recorderView];
    [self.playerView distanceLeftToSuperview:0.0f];
    [self.playerView distanceRightToSuperview:0.0f];
    [self.playerView setHeightConstraint:1.0f];
    
}

- (void)audioManagerDidFinishRecording
{
    NSURL *fileURL = [OSAudioManager sharedInstance].recorder.url;
    [self.playerView.audioFilesURLArray addObject:fileURL];
    [self.playerView addTableViewRow];
    [self.playerView changeTableViewHeight:YES];
}

- (void)audioPlayerView:(OSAudioPlayerView *)view
    didRowNumberChanged:(BOOL)addedRow
    withTableViewHeight:(CGFloat)height
{
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.playerView.constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight)
        {
            heightConstraint = constraint;
            break;
        }
    }
    heightConstraint.constant = height;
    if (addedRow)
    {
        self.recorderView.recordNumber++;
    }
}


@end
