//
//  OSVoiceRecorderView.m
//  OSVoiceRecorder
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSVoiceRecorderView.h"
#import <AVFoundation/AVAudioSession.h>

static CGFloat const kTopOffset = 10.0f;

@interface OSVoiceRecorderView ()

@property (nonatomic, strong) UIView            *startRecordView;
@property (nonatomic, strong) UIImageView       *recordImageView;
@property (nonatomic, strong) UILabel           *startRecordLabel;

@property (nonatomic, strong) UIView            *recordingView;
@property (nonatomic, strong) UIButton          *stopRecordingButton;
@property (nonatomic, strong) UIView            *recordingProcessView;
@property (nonatomic, strong) UILabel           *recordingTimePassedLabel;

@property (nonatomic, strong) UIView            *playView;
@property (nonatomic, strong) UIButton          *playRecordingButton;
@property (nonatomic, strong) UISlider          *playSeekableSlider;
@property (nonatomic, strong) UILabel           *playTimePassedLabel;

@property (nonatomic, assign) BOOL playing;

@end

@implementation OSVoiceRecorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self)
    {
        [self initComponents];
        [self loadComponents];
    }
    return self;
}

- (void)initComponents
{
    // Before Record
    self.startRecordView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                    0.0f,
                                                                    CGRectGetWidth(self.frame) - kTopOffset * 2,
                                                                    55.0f)];
    self.startRecordView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
    [self.startRecordView addGestureRecognizer:recognizer];
    self.startRecordView.center = CGPointMake(self.startRecordView.center.x, CGRectGetMidY(self.bounds));
    
    self.recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recorder"]];
    self.recordImageView.frame = CGRectMake(kTopOffset, 0.0f, 30.0f, 30.0f);
    self.recordImageView.backgroundColor = [UIColor clearColor];
    self.recordImageView.center = CGPointMake(self.recordImageView.center.x, CGRectGetMidY(self.startRecordView.bounds));

    self.startRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTopOffset * 5, 0.0f, 200.0f, 30.0f)];
    self.startRecordLabel.text = @"Ses kaydına başla!";
    self.startRecordLabel.font = [UIFont systemFontOfSize:14.0f];
    self.startRecordLabel.backgroundColor = [UIColor clearColor];
    self.startRecordLabel.textColor = [UIColor blackColor];
    self.startRecordLabel.center = CGPointMake(self.startRecordLabel.center.x, CGRectGetMidY(self.startRecordView.bounds));
    
    // Recording
    self.recordingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                  0.0f,
                                                                  CGRectGetWidth(self.frame),
                                                                  55.0f)];
    self.recordingView.backgroundColor = [UIColor clearColor];
    self.recordingView.center = CGPointMake(self.recordingView.center.x, CGRectGetMidY(self.bounds));
    self.recordingView.alpha = 0.0f;
    
    self.stopRecordingButton = [[UIButton alloc] initWithFrame:CGRectMake(kTopOffset, 0.0f, 30.0f, 30.0f)];
    [self.stopRecordingButton addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopRecordingButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    self.stopRecordingButton.backgroundColor = [UIColor clearColor];
    self.stopRecordingButton.center = CGPointMake(self.stopRecordingButton.center.x, CGRectGetMidY(self.recordingView.bounds));
    
    self.recordingProcessView = [[UIView alloc] initWithFrame:CGRectMake(kTopOffset * 5,
                                                                         0.0f,
                                                                         CGRectGetWidth(self.frame) - 110,
                                                                         10.0f)];
    self.recordingProcessView.backgroundColor = [UIColor redColor];
    self.recordingProcessView.center = CGPointMake(self.recordingProcessView.center.x, CGRectGetMidY(self.recordingView.bounds));
    
    self.recordingTimePassedLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.recordingView.frame) - 55, 0.0f, 50, 20.0f)];
    self.recordingTimePassedLabel.backgroundColor = [UIColor clearColor];
    self.recordingTimePassedLabel.text = @"00:00";
    self.recordingTimePassedLabel.textAlignment = NSTextAlignmentCenter;
    self.recordingTimePassedLabel.font = [UIFont systemFontOfSize:14.0f];
    self.recordingTimePassedLabel.center = CGPointMake(self.recordingTimePassedLabel.center.x, CGRectGetMidY(self.recordingView.bounds));
    
    // Recorded - Play view
    self.playView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                             0.0f,
                                                             CGRectGetWidth(self.frame),
                                                             55.0f)];
    self.playView.backgroundColor = [UIColor clearColor];
    self.playView.center = CGPointMake(self.playView.center.x, CGRectGetMidY(self.bounds));
    self.playView.alpha = 0.0f;
    
    self.playRecordingButton = [[UIButton alloc] initWithFrame:CGRectMake(kTopOffset, 0.0f, 30.0f, 30.0f)];
    [self.playRecordingButton addTarget:self action:@selector(playPauseRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.playRecordingButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.playRecordingButton.backgroundColor = [UIColor clearColor];
    self.playRecordingButton.center = CGPointMake(self.playRecordingButton.center.x, CGRectGetMidY(self.playView.bounds));
    
    self.playSeekableSlider = [[UISlider alloc] initWithFrame:CGRectMake(kTopOffset * 5,
                                                                         0.0f,
                                                                         CGRectGetWidth(self.frame) - 110,
                                                                         10.0f)];
    self.playSeekableSlider.backgroundColor = [UIColor clearColor];
    [self.playSeekableSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.playSeekableSlider setMinimumTrackTintColor:[UIColor redColor]];
    [self.playSeekableSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    [self.playSeekableSlider setThumbTintColor:[UIColor redColor]];
    self.playSeekableSlider.center = CGPointMake(self.playSeekableSlider.center.x, CGRectGetMidY(self.playView.bounds));
    
    self.playTimePassedLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.playView.frame) - 55, 0.0f, 50, 20.0f)];
    self.playTimePassedLabel.backgroundColor = [UIColor clearColor];
    self.playTimePassedLabel.text = @"00:00";
    self.playTimePassedLabel.textAlignment = NSTextAlignmentCenter;
    self.playTimePassedLabel.font = [UIFont systemFontOfSize:14.0f];
    self.playTimePassedLabel.center = CGPointMake(self.playTimePassedLabel.center.x, CGRectGetMidY(self.playView.bounds));
    
}

- (void)loadComponents
{
    [self addSubview:self.startRecordView];
    [self.startRecordView addSubview:self.startRecordLabel];
    [self.startRecordView addSubview:self.recordImageView];
    
    [self addSubview:self.recordingView];
    [self.recordingView addSubview:self.stopRecordingButton];
    [self.recordingView addSubview:self.recordingProcessView];
    [self.recordingView addSubview:self.recordingTimePassedLabel];
    
    [self addSubview:self.playView];
    [self.playView addSubview:self.playRecordingButton];
    [self.playView addSubview:self.playSeekableSlider];
    [self.playView addSubview:self.playTimePassedLabel];
}

- (void)showPlayView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.recordingView.alpha = 0.0f;
        [self layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.2f animations:^{
        self.playView.alpha = 1.0f;
        [self layoutIfNeeded];
    }];
}

- (void)showInitialPlayState
{
    self.playSeekableSlider.value = 0.0f;
    self.playing = NO;
    [self.playRecordingButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

#pragma mark - Actions
- (void)startRecord:(UIGestureRecognizer *)recognizer
{
//    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//        
//    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.startRecordView.alpha = 0.0f;
        [self layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.2f animations:^{
        self.recordingView.alpha = 1.0f;
        [self layoutIfNeeded];
    }];
    
    if ([self.delegate respondsToSelector:@selector(voiceRecorderViewDidTappedRecordButton)])
    {
        [self.delegate voiceRecorderViewDidTappedRecordButton];
    }
}

- (void)stopRecord:(UIButton *)button
{
    [self showPlayView];
    if ([self.delegate respondsToSelector:@selector(voiceRecorderViewDidTappedStopRecordButton)])
    {
        [self.delegate voiceRecorderViewDidTappedStopRecordButton];
    }
}

- (void)playPauseRecord:(UIButton *)button
{
    if (!self.playing)
    {
        [self.playRecordingButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(voiceRecorderViewDidTappedPlayRecordButton)])
        {
            [self.delegate voiceRecorderViewDidTappedPlayRecordButton];
        }
    }
    else
    {
        [self.playRecordingButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(voiceRecorderViewDidTappedPauseRecordButton)])
        {
            [self.delegate voiceRecorderViewDidTappedPauseRecordButton];
        }
    }
    self.playing = !self.playing;
}

- (void)setSliderMaximumValue:(CGFloat)value
{
    self.playSeekableSlider.maximumValue = value;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(voiceRecorderSliderDidChange:)])
    {
        [self.delegate voiceRecorderSliderDidChange:slider.value];
    }
}

#pragma mark - UI Updates
- (void)updateRecordTimeLabel:(NSString *)timeString
{
    self.recordingTimePassedLabel.text = timeString;
}

- (void)updatePlayTimeLabel:(NSString *)timeString
{
    self.playTimePassedLabel.text = timeString;
}

- (void)updateSliderValue:(CGFloat)duration
{
    self.playSeekableSlider.value = duration;
}

#pragma mark - UISlider Image
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 10.0f, 10.0f)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
