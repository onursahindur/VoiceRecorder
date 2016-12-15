//
//  OSAudioManager.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioManager.h"

@interface OSAudioManager () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@end

@implementation OSAudioManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [OSAudioManager new];
        [((OSAudioManager *)sharedInstance) makeInitializationConfigurations];
    });
    return sharedInstance;
}

- (void)makeInitializationConfigurations
{
    
}

- (void)prepareToRecord:(NSInteger)recordNumber
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
    NSMutableDictionary *recordSettings = [NSMutableDictionary new];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    NSString *recordName = [NSString stringWithFormat:@"Recording-%ld.m4a", (long)recordNumber];
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], recordName, nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)startRecording
{
    if ([self.player isPlaying])
    {
        [self.timer invalidate];
        [self.player stop];
    }
    self.player = nil;
    self.player.delegate = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerTickTock:)
                                                userInfo:nil
                                                 repeats:YES];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder record];
}

- (void)stopRecording
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.recorder stop];
}

- (void)prepareToPlay:(NSURL *)fileURL
       withPauseStart:(NSDate *)pauseStart
 withPreviousFireDate:(NSDate *)previousFireDate
      withCurrentTime:(NSTimeInterval)currentTime
{
    if ([self.player isPlaying])
    {
        [self.timer invalidate];
        [self.player stop];
    }
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.player.delegate = self;
    self.player.currentTime = currentTime;
    if (pauseStart && previousFireDate)
    {
        float pauseTime = -1 * [pauseStart timeIntervalSinceNow];
        [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    }
    else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                    selector:@selector(timerTickTock:)
                                                    userInfo:@{@"player":@1}
                                                     repeats:YES];
    }
}

- (void)startPlaying
{
    [self.player play];
}

- (void)pausePlaying
{
    [self.player pause];
}

- (void)timerTickTock:(NSTimer *)sender
{
    float minutes;
    float seconds;
    if (sender.userInfo)
    {
        minutes = floor(self.player.currentTime / 60);
        seconds = self.player.currentTime - (minutes * 60);
    }
    else
    {
        minutes = floor(self.recorder.currentTime / 60);
        seconds = self.recorder.currentTime - (minutes * 60);
    }
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02.0f:%02.0f",
                      minutes, seconds];
    NSDictionary *userInfo = @{@"time":time};
    [[NSNotificationCenter defaultCenter] postNotificationName:timerTicked
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - AVAudio delegates
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder
                           successfully:(BOOL)flag
{
    [self.timer invalidate];
    NSDictionary *userInfo = @{@"successful":[NSNumber numberWithBool:flag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:recordingFinished
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.timer invalidate];
    NSDictionary *userInfo = @{@"successful":[NSNumber numberWithBool:flag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:playingFinished
                                                        object:self
                                                      userInfo:userInfo];
}

@end
