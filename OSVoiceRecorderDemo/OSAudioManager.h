//
//  OSAudioManager.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const timerTicked              = @"AudioManagerTimerTicked";
static NSString *const recordingFinished        = @"AudioManagerFinishedRecording";
static NSString *const playingFinished          = @"AudioManagerFinishedPlaying";


@interface OSAudioManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) AVAudioRecorder   *recorder;
@property (nonatomic, strong) AVAudioPlayer     *player;
@property (nonatomic, strong) NSTimer           *timer;

- (void)prepareToRecord:(NSInteger)recordNumber;
- (void)startRecording;
- (void)stopRecording;

- (void)prepareToPlay:(NSURL *)fileURL
       withPauseStart:(NSDate *)pauseStart
 withPreviousFireDate:(NSDate *)previousFireDate
      withCurrentTime:(NSTimeInterval)currentTime;
- (void)startPlaying;
- (void)pausePlaying;

@end
