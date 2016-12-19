//
//  OSAudioRecorderView.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioRecorderView.h"
#import "UIView+LayoutConstraints.h"
#import "OSAudioManager.h"

@interface OSAudioRecorderView ()

@end

@implementation OSAudioRecorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)initSubViews
{
    // waiting state
    self.waitingView = [UIView new];
    self.waitingView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(startRecord:)];
    [self.waitingView addGestureRecognizer:recognizer];
    self.waitingView.alpha = 1.0f;
    [self addSubview:self.waitingView];
    
    self.recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_record_record"]];
    [self.waitingView addSubview:self.recordImageView];
    
    self.startRecordLabel = [UILabel new];
    self.startRecordLabel.text = @"Ses kaydına başla!";
    self.startRecordLabel.font = [UIFont systemFontOfSize:14.0f];
    self.startRecordLabel.backgroundColor = [UIColor clearColor];
    self.startRecordLabel.textColor = [UIColor blackColor];
    [self.waitingView addSubview:self.startRecordLabel];
    
    // recording state
    self.recordingView = [UIView new];
    self.recordingView.backgroundColor = [UIColor clearColor];
    self.recordingView.alpha = 0.0f;
    [self addSubview:self.recordingView];
    
    self.stopRecordButton = [UIButton new];
    [self.stopRecordButton addTarget:self action:@selector(stopRecord:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.stopRecordButton setBackgroundImage:[UIImage imageNamed:@"voice_record_stop"]
                                     forState:UIControlStateNormal];
    [self.recordingView addSubview:self.stopRecordButton];
    
    self.recordingStatusView = [UIView new];
    self.recordingStatusView.backgroundColor = [UIColor redColor];
    [self.recordingView addSubview:self.recordingStatusView];
    
    self.recordingTimeLabel = [UILabel new];
    self.recordingTimeLabel.backgroundColor = [UIColor clearColor];
    self.recordingTimeLabel.text = @"00:00";
    self.recordingTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.recordingTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.recordingView addSubview:self.recordingTimeLabel];
    
}

- (void)addLayoutConstraints
{
    // waiting state
    self.waitingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.waitingView distanceTopToSuperview:0.0f];
    [self.waitingView distanceBottomToSuperview:0.0f];
    [self.waitingView distanceLeftToSuperview:0.0f];
    [self.waitingView distanceRightToSuperview:0.0f];
    
    self.recordImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordImageView setWidthConstraint:30.0f];
    [self.recordImageView setHeightConstraint:30.0f];
    [self.recordImageView distanceLeftToSuperview:10.0f];
    [self.recordImageView centerYInSuperview];
    
    
    self.startRecordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startRecordLabel distance:10.0f toLeftView:self.recordImageView];
    [self.startRecordLabel distanceRightToSuperview:30.0f];
    [self.startRecordLabel setHeightConstraint:30.0f];
    [self.startRecordLabel centerYInSuperview];
    
    
    // recording state
    self.recordingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordingView distanceTopToSuperview:0.0f];
    [self.recordingView distanceBottomToSuperview:0.0f];
    [self.recordingView distanceLeftToSuperview:0.0f];
    [self.recordingView distanceRightToSuperview:0.0f];
    
    self.stopRecordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stopRecordButton setWidthConstraint:30.0f];
    [self.stopRecordButton setHeightConstraint:30.0f];
    [self.stopRecordButton distanceLeftToSuperview:10.0f];
    [self.stopRecordButton centerYInSuperview];
    
    self.recordingTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordingTimeLabel distanceRightToSuperview:40.0f];
    [self.recordingTimeLabel setHeightConstraint:30.0f];
    [self.recordingTimeLabel setWidthConstraint:50.0f];
    [self.recordingTimeLabel centerYInSuperview];
    
    self.recordingStatusView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordingStatusView distance:10.0f toLeftView:self.stopRecordButton];
    [self.recordingStatusView distance:10.0f toRightView:self.recordingTimeLabel];
    [self.recordingStatusView setHeightConstraint:10.0f];
    [self.recordingStatusView centerYInSuperview];
    
}

- (void)showRecorderState:(AudioRecorderViewState)state
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.waitingView.alpha = state == AudioRecorderViewStateWaiting ? 1.0f : 0.0f;
        strongSelf.recordingView.alpha = state == AudioRecorderViewStateWaiting ? 0.0f : 1.0f;
        [strongSelf layoutIfNeeded];
    }];
    self.currentState = state;
}

#pragma mark - Actions
- (void)startRecord:(UITapGestureRecognizer *)recognizer
{
    [self showRecorderState:AudioRecorderViewStateRecording];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeLabel:)
                                                 name:timerTicked
                                               object:[OSAudioManager sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerDidFinishRecording:)
                                                 name:recordingFinished
                                               object:[OSAudioManager sharedInstance]];
    [[OSAudioManager sharedInstance] prepareToRecord:self.recordNumber];
    [[OSAudioManager sharedInstance] startRecording];
}

- (void)stopRecord:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:timerTicked
                                                  object:[OSAudioManager sharedInstance]];
    [[OSAudioManager sharedInstance] stopRecording];
    self.recordingTimeLabel.text = @"00:00";
}

#pragma mark - Notifications
- (void)updateTimeLabel:(NSNotification *)notification
{
    self.recordingTimeLabel.text = [NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"time"]];
}

- (void)managerDidFinishRecording:(NSNotification *)notification
{
    [self showRecorderState:AudioRecorderViewStateWaiting];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:recordingFinished
                                                  object:[OSAudioManager sharedInstance]];
    if ([self.delegate respondsToSelector:@selector(audioManagerDidFinishRecording:)])
    {
        [self.delegate audioManagerDidFinishRecording:[notification.userInfo objectForKey:@"url"]];
    }
}

@end
