//
//  OSVoiceRecorder.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSVoiceRecorder.h"

@interface OSVoiceRecorder () <OSVoiceRecorderViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession    *session;
@property (nonatomic, strong) AVAudioRecorder   *recorder;
@property (nonatomic, strong) AVAudioPlayer     *player;
@property (nonatomic, strong) NSTimer           *timer;
@property (nonatomic, strong) NSDate            *pauseStart, *previousFireDate;

@end

@implementation OSVoiceRecorder

- (instancetype)initDefault
{
    self = [super init];
    if (self)
    {
        _session = [AVAudioSession sharedInstance];
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        NSString *recordName = [NSString stringWithFormat:@"Recording.m4a"];
        NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], recordName, nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
    }
    return self;
}

- (OSVoiceRecorderView *)addRecordViewToView:(UIView *)view
                                   withFrame:(CGRect)frame
                          withViewController:(UIViewController *)viewController
{
    self.recorderView = [[OSVoiceRecorderView alloc] initWithFrame:frame];
    self.recorderView.delegate = self;
    [view addSubview:self.recorderView];
    return self.recorderView;
}

#pragma mark - RecorderView Delegates
- (void)voiceRecorderViewDidTappedRecordButton
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateLabel)
                                                userInfo:nil
                                                 repeats:YES];
    [self.session setActive:YES error:nil];
    [self.recorder record];
}

- (void)voiceRecorderViewDidTappedStopRecordButton
{
    [self.session setActive:NO error:nil];
    [self.recorder stop];
}

- (void)voiceRecorderViewDidTappedPlayRecordButton
{
    if (!self.player)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                    selector:@selector(updateSliderWithLabel)
                                                    userInfo:nil
                                                     repeats:YES];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        [self.recorderView setSliderMaximumValue:self.player.duration];
        [self.player setDelegate:self];
        
    }
    else
    {
        float pauseTime = -1 * [self.pauseStart timeIntervalSinceNow];
        [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
    }
    [self.player play];
}

- (void)voiceRecorderViewDidTappedPauseRecordButton
{
    self.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    self.previousFireDate = [self.timer fireDate];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.player pause];
}

- (void)voiceRecorderSliderDidChange:(CGFloat)value
{
    [self.player setCurrentTime:value];
    [self updatePLayTimeLabel];
}

#pragma mark - AVSession Delegates
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    self.recorded = YES;
    [self.timer invalidate];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.recorderView showInitialPlayState];
}

#pragma mark - Update UI methods
- (void)updateLabel
{
    float minutes = floor(self.recorder.currentTime / 60);
    float seconds = self.recorder.currentTime - (minutes * 60);
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02.0f:%02.0f",
                      minutes, seconds];
    [self.recorderView updateRecordTimeLabel:time];
}

- (void)updatePLayTimeLabel
{
    float minutes = floor(self.player.currentTime / 60);
    float seconds = self.player.currentTime - (minutes * 60);
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02.0f:%02.0f",
                      minutes, seconds];
    [self.recorderView updatePlayTimeLabel:time];
}

- (void)updateSliderWithLabel
{
    [self updatePLayTimeLabel];
    [self.recorderView updateSliderValue:self.player.currentTime];
}

@end
