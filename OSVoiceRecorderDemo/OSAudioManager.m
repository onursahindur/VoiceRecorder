//
//  OSAudioManager.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioManager.h"

@interface OSAudioManager () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray        *recordings;
@property (nonatomic, assign) NSTimeInterval        intervalTimeElapsed;
@property (nonatomic, strong) NSDate                *pauseStart;
@property (nonatomic, strong) NSDate                *previousFireDate;
@property (nonatomic, strong) NSDate                *recordingStartDate;
@property (nonatomic, assign) BOOL                  isInterrupted;
@property (nonatomic, assign) NSInteger             preInterruptionDuration;

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

#pragma mark - Record Related
- (void)prepareToRecord:(NSInteger)recordNumber
{
    [self clearContentsOfDirectory:NSTemporaryDirectory()];
    self.recordings = [NSMutableArray new];
    self.currentRecordNumber = recordNumber;
    
    // Add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    
    // Init session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeSpokenAudio
                                       error:nil];
    
    // Init recorder
    [self initRecording];
}

- (void)initRecording
{
    // Init record settings
    NSMutableDictionary *recordSettings = [NSMutableDictionary new];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    NSString *recordName = [NSString stringWithFormat:@"recordingPart-%ld.m4a", (long)self.recordings.count];
    NSArray *appendedAudioPath = @[NSTemporaryDirectory(), recordName]; // name of the final audio file
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:appendedAudioPath];
    
    // Add new recording to mutable array
    [self.recordings addObject:outputFileURL];
    
    // Init recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL
                                                settings:recordSettings
                                                   error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)startRecording
{
    // Stop player
    if ([self.player isPlaying])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:playingFinished
                                                            object:self
                                                          userInfo:nil];
        [self.timer invalidate];
        [self.player stop];
    }
    self.player = nil;
    self.player.delegate = nil;
    
    // Prepare timer
    self.previousFireDate = nil;
    self.pauseStart = nil;
    [self setTimer];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.intervalTimeElapsed = 0;
    self.recordingStartDate = [NSDate date];
    if (self.isInterrupted)
    {
        self.intervalTimeElapsed = self.preInterruptionDuration;
        self.isInterrupted = NO;
    }
    
    [self.recorder record];
}

- (void)stopRecording
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.recorder stop];
}

#pragma mark - Play Related
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                selector:@selector(timerTickTock:)
                                                userInfo:@{@"player":@1}
                                                 repeats:YES];
    if (pauseStart && previousFireDate)
    {
        float pauseTime = -1 * [pauseStart timeIntervalSinceNow];
        [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    }
}

- (void)startPlaying
{
    [self.player play];
}

- (void)pausePlaying
{
    [self.timer invalidate];
    [self.player pause];
}

- (void)removeFile:(NSString *)filePath
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

- (void)clearContentsOfDirectory:(NSString*)directory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error])
    {
        [fm removeItemAtURL:[NSURL fileURLWithPathComponents:@[directory, file]] error:&error];
    }
}

#pragma mark - Timer Related
- (void)pauseTimer
{
    self.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    self.previousFireDate = [self.timer fireDate];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerTickTock:)
                                                userInfo:nil
                                                 repeats:YES];
    if (self.pauseStart && self.previousFireDate)
    {
        float pauseTime = - 1 * [self.pauseStart timeIntervalSinceNow];
        [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
    }
    NSLog(@"timer set!");
}

- (void)timerTickTock:(NSTimer *)sender
{
    float minutes;
    float seconds;
    if (!sender.userInfo) self.intervalTimeElapsed++;
    minutes = floor((sender.userInfo ? self.player.currentTime : self.intervalTimeElapsed) / 60);
    seconds = (sender.userInfo ? self.player.currentTime : self.intervalTimeElapsed) - (minutes * 60);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02.0f:%02.0f",
                      minutes, seconds];
    NSDictionary *userInfo = @{@"time":time};
    [[NSNotificationCenter defaultCenter] postNotificationName:timerTicked
                                                        object:self
                                                      userInfo:userInfo];
    NSLog(@"tiktok");
}

#pragma mark - AVAudio delegates
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder
                           successfully:(BOOL)flag
{
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:[AVAudioSession sharedInstance]];
    
    __weak typeof (self) weakSelf = self;
    [self appendAudiosAtURLs:self.recordings completion:^(BOOL success, NSURL *outputUrl)
    {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf clearContentsOfDirectory:NSTemporaryDirectory()];
        [strongSelf.timer invalidate];
        strongSelf.timer = nil;
        NSDictionary *userInfo = @{@"successful":[NSNumber numberWithBool:flag],
                                   @"url": outputUrl};
        [[NSNotificationCenter defaultCenter] postNotificationName:recordingFinished
                                                            object:strongSelf
                                                          userInfo:userInfo];
    }];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.timer invalidate];
    self.timer = nil;
    NSDictionary *userInfo = @{@"successful":[NSNumber numberWithBool:flag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:playingFinished
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)handleAudioSessionInterruption:(NSNotification*)notification
{
    AVAudioSessionInterruptionType interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    AVAudioSessionInterruptionOptions interruptionOption = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
    
    switch (interruptionType)
    {
        case AVAudioSessionInterruptionTypeBegan:
        {
            self.isInterrupted = YES;
            self.preInterruptionDuration += self.recorder.currentTime; // time elapsed
            [self.recorder pause];
            [self pauseTimer];
            
            self.recorder.delegate = nil;   // Set delegate to nil so that audioRecorderDidFinishRecording may not get called
            [self.recorder stop];           // stop recording
        }
            break;
        case AVAudioSessionInterruptionTypeEnded:
        {
            if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume)
            {
                [self initRecording];
                [self startRecording];
            }
        }
            break;
        default:
            break;
    }
}

// gets an array of audios and append them to one another
// the basic logic was derived from here: http://stackoverflow.com/a/16040992/634958
// i modified this logic to append multiple files
- (void)appendAudiosAtURLs:(NSMutableArray*)urls completion:(void(^)(BOOL success, NSURL* outputUrl))handler
{
    // Create a new audio track we can append to
    AVMutableComposition* composition = [AVMutableComposition composition];
    AVMutableCompositionTrack* appendedAudioTrack =
    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                             preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Grab the first audio track that need to be appended
    AVURLAsset* originalAsset = [[AVURLAsset alloc]
                                 initWithURL:urls.firstObject options:nil];
    [urls removeObjectAtIndex:0];
    
    NSError* error = nil;
    
    // Grab the first audio track and insert it into our appendedAudioTrack
    AVAssetTrack *originalTrack = [[originalAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, originalAsset.duration);
    [appendedAudioTrack insertTimeRange:timeRange
                                ofTrack:originalTrack
                                 atTime:kCMTimeZero
                                  error:&error];
    CMTime duration = originalAsset.duration;
    
    if (error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, Nil);
            });
        }
    }
    
    for (NSURL* audioUrl in urls) {
        AVURLAsset* newAsset = [[AVURLAsset alloc]
                                initWithURL:audioUrl options:nil];
        
        // Grab the rest of the audio tracks and insert them at the end of each other
        AVAssetTrack *newTrack = [[newAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        timeRange = CMTimeRangeMake(kCMTimeZero, newAsset.duration);
        [appendedAudioTrack insertTimeRange:timeRange
                                    ofTrack:newTrack
                                     atTime:duration
                                      error:&error];
        
        duration = appendedAudioTrack.timeRange.duration;
        
        if (error) {
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(NO, Nil);
                });
            }
        }
    }
    
    // Create a new audio file using the appendedAudioTrack
    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (!exportSession) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, Nil);
            });
        }
    }
    
    NSString *finalRecordingName = [NSString stringWithFormat:@"Recording-%ld-%@.m4a", self.currentRecordNumber, [NSDate date]];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    exportSession.outputURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:finalRecordingName]];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = NO;
        // exported successfully?
        switch (exportSession.status) {
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCompleted: {
                success = YES;
                break;
            }
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
        if (handler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(success, exportSession.outputURL);
            });
        }
    }];
}

@end
