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
#import <AVFoundation/AVFoundation.h>

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


//@interface XDRecordViewController ()
//{
//    AVAudioRecorder *recorder;
//    
//    __weak IBOutlet UIButton* btnRecord;
//    __weak IBOutlet UIButton* btnSave;
//    __weak IBOutlet UIButton* btnDiscard;
//    __weak IBOutlet UILabel*  lblTimer; // a UILabel to display the recording time
//    
//    // some variables to display the timer on a lblTimer
//    NSTimer* timer;
//    NSTimeInterval intervalTimeElapsed;
//    NSDate* pauseStart;
//    NSDate* previousFireDate;
//    NSDate* recordingStartDate;
//    
//    // interruption handling variables
//    BOOL isInterrupted;
//    NSInteger preInterruptionDuration;
//    
//    NSMutableArray* recordings; // an array of recordings to be merged in the end
//}
//@end
//
//@implementation XDRecordViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // Make this class listen to the AVAudioSessionInterruptionNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleAudioSessionInterruption:)
//                                                 name:AVAudioSessionInterruptionNotification
//                                               object:[AVAudioSession sharedInstance]];
//    
//    [self clearContentsOfDirectory:NSTemporaryDirectory()]; // clear contents of NSTemporaryDirectory()
//    
//    recordings = [NSMutableArray new]; // initialize recordings
//    
//    [self setupAudioSession]; // setup the audio session. you may customize it according to your requirements
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [self initRecording];   // start recording as soon as the view appears
//}
//
//- (void)dealloc
//{
//    [self clearContentsOfDirectory:NSTemporaryDirectory()]; // remove all files files from NSTemporaryDirectory
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self]; // remove this class from NSNotificationCenter
//}
//
//#pragma mark - Event Listeners
//
//// called when recording button is tapped
//- (IBAction) btnRecordingTapped:(UIButton*)sender
//{
//    sender.selected = !sender.selected; // toggle the button
//    
//    if (sender.selected) { // resume recording
//        [recorder record];
//        [self resumeTimer];
//    } else { // pause recording
//        [recorder pause];
//        [self pauseTimer];
//    }
//}
//
//// called when save button is tapped
//- (IBAction) btnSaveTapped:(UIButton*)sender
//{
//    [self pauseTimer]; // pause the timer
//    
//    // disable the UI while the recording is saving so that user may not press the save, record or discard button again
//    btnSave.enabled = NO;
//    btnRecord.enabled = NO;
//    btnDiscard.enabled = NO;
//    
//    [recorder stop]; // stop the AVAudioRecorder so that the audioRecorderDidFinishRecording delegate function may get called
//    
//    // Deactivate the AVAudioSession
//    NSError* error;
//    [[AVAudioSession sharedInstance] setActive:NO error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    }
//}
//
//// called when discard button is tapped
//- (IBAction) btnDiscardTapped:(id)sender
//{
//    [self stopTimer]; // stop the timer
//    
//    recorder.delegate = Nil; // set delegate to Nil so that audioRecorderDidFinishRecording delegate function may not get called
//    [recorder stop];  // stop the recorder
//    
//    // Deactivate the AVAudioSession
//    NSError* error;
//    [[AVAudioSession sharedInstance] setActive:NO error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//#pragma mark - Notification Listeners
//// called when an AVAudioSessionInterruption occurs
//- (void)handleAudioSessionInterruption:(NSNotification*)notification
//{
//    AVAudioSessionInterruptionType interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
//    AVAudioSessionInterruptionOptions interruptionOption = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
//    
//    switch (interruptionType) {
//        case AVAudioSessionInterruptionTypeBegan:{
//            // • Recording has stopped, already inactive
//            // • Change state of UI, etc., to reflect non-recording state
//            preInterruptionDuration += recorder.currentTime; // time elapsed
//            if(btnRecord.selected) {    // timer is already running
//                [self btnRecordingTapped:btnRecord];  // pause the recording and pause the timer
//            }
//            
//            recorder.delegate = Nil; // Set delegate to nil so that audioRecorderDidFinishRecording may not get called
//            [recorder stop];    // stop recording
//            isInterrupted = YES;
//            break;
//        }
//        case AVAudioSessionInterruptionTypeEnded:{
//            // • Make session active
//            // • Update user interface
//            // • AVAudioSessionInterruptionOptionShouldResume option
//            if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume) {
//                // Here you should create a new recording
//                [self initRecording];   // create a new recording
//                [self btnRecordingTapped:btnRecord];
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark - AVAudioRecorderDelegate
//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
//{
//    [self appendAudiosAtURLs:recordings completion:^(BOOL success, NSURL *outputUrl) {
//        // do whatever you want with the new audio file :)
//    }];
//}
//
//#pragma mark - Timer
//- (void)timerFired:(NSTimer*)timer
//{
//    intervalTimeElapsed++;
//    [self updateDisplay];
//}
//
//// function to time string
//- (NSString*) timerStringSinceTimeInterval:(NSTimeInterval)timeInterval
//{
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    return [dateFormatter stringFromDate:timerDate];
//}
//
//// called when recording pauses
//- (void) pauseTimer
//{
//    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
//    
//    previousFireDate = [timer fireDate];
//    
//    [timer setFireDate:[NSDate distantFuture]];
//}
//
//- (void) resumeTimer
//{
//    if (!timer) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                 target:self
//                                               selector:@selector(timerFired:)
//                                               userInfo:Nil
//                                                repeats:YES];
//        return;
//    }
//    
//    float pauseTime = - 1 * [pauseStart timeIntervalSinceNow];
//    
//    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
//}
//
//- (void)stopTimer
//{
//    [self updateDisplay];
//    [timer invalidate];
//    timer = nil;
//}
//
//- (void)updateDisplay
//{
//    lblTimer.text = [self timerStringSinceTimeInterval:intervalTimeElapsed];
//}
//
//#pragma mark - Helper Functions
//- (void) initRecording
//{
//    
//    // Set the audio file
//    NSString* name = [NSString stringWithFormat:@"recording_%@.m4a", @(recordings.count)]; // creating a unique name for each audio file
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:@[NSTemporaryDirectory(), name]];
//    
//    [recordings addObject:outputFileURL];
//    
//    // Define the recorder settings
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    
//    [recordSetting setValue:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
//    [recordSetting setValue:@(44100.0) forKey:AVSampleRateKey];
//    [recordSetting setValue:@(1) forKey:AVNumberOfChannelsKey];
//    
//    NSError* error;
//    // Initiate and prepare the recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&error];
//    recorder.delegate = self;
//    recorder.meteringEnabled = YES;
//    [recorder prepareToRecord];
//    
//    if (![AVAudioSession sharedInstance].inputAvailable) { // can not record audio if mic is unavailable
//        NSLog(@"Error: Audio input device not available!");
//        return;
//    }
//    
//    intervalTimeElapsed = 0;
//    recordingStartDate = [NSDate date];
//    
//    if (isInterrupted) {
//        intervalTimeElapsed = preInterruptionDuration;
//        isInterrupted = NO;
//    }
//    
//    // Activate the AVAudioSession
//    [[AVAudioSession sharedInstance] setActive:YES error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    }
//    
//    recordingStartDate = [NSDate date];  // Set the recording start date
//    [self btnRecordingTapped:btnRecord];
//}
//
//- (void)setupAudioSession
//{
//    
//    static BOOL audioSessionSetup = NO;
//    if (audioSessionSetup) {
//        return;
//    }
//    
//    AVAudioSession* session = [AVAudioSession sharedInstance];
//    
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord
//             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
//                   error:Nil];
//    
//    [session setMode:AVAudioSessionModeSpokenAudio error:nil];
//    
//    audioSessionSetup = YES;
//}
//
//// gets an array of audios and append them to one another
//// the basic logic was derived from here: http://stackoverflow.com/a/16040992/634958
//// i modified this logic to append multiple files
//- (void) appendAudiosAtURLs:(NSMutableArray*)urls completion:(void(^)(BOOL success, NSURL* outputUrl))handler
//{
//    // Create a new audio track we can append to
//    AVMutableComposition* composition = [AVMutableComposition composition];
//    AVMutableCompositionTrack* appendedAudioTrack =
//    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
//                             preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    // Grab the first audio track that need to be appended
//    AVURLAsset* originalAsset = [[AVURLAsset alloc]
//                                 initWithURL:urls.firstObject options:nil];
//    [urls removeObjectAtIndex:0];
//    
//    NSError* error = nil;
//    
//    // Grab the first audio track and insert it into our appendedAudioTrack
//    AVAssetTrack *originalTrack = [[originalAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, originalAsset.duration);
//    [appendedAudioTrack insertTimeRange:timeRange
//                                ofTrack:originalTrack
//                                 atTime:kCMTimeZero
//                                  error:&error];
//    CMTime duration = originalAsset.duration;
//    
//    if (error) {
//        if (handler) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                handler(NO, Nil);
//            });
//        }
//    }
//    
//    for (NSURL* audioUrl in urls) {
//        AVURLAsset* newAsset = [[AVURLAsset alloc]
//                                initWithURL:audioUrl options:nil];
//        
//        // Grab the rest of the audio tracks and insert them at the end of each other
//        AVAssetTrack *newTrack = [[newAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//        timeRange = CMTimeRangeMake(kCMTimeZero, newAsset.duration);
//        [appendedAudioTrack insertTimeRange:timeRange
//                                    ofTrack:newTrack
//                                     atTime:duration
//                                      error:&error];
//        
//        duration = appendedAudioTrack.timeRange.duration;
//        
//        if (error) {
//            if (handler) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    handler(NO, Nil);
//                });
//            }
//        }
//    }
//    
//    // Create a new audio file using the appendedAudioTrack
//    AVAssetExportSession* exportSession = [AVAssetExportSession
//                                           exportSessionWithAsset:composition
//                                           presetName:AVAssetExportPresetAppleM4A];
//    if (!exportSession) {
//        if (handler) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                handler(NO, Nil);
//            });
//        }
//    }
//    
//    NSArray* appendedAudioPath = @[NSTemporaryDirectory(), @"temp.m4a"]; // name of the final audio file
//    exportSession.outputURL = [NSURL fileURLWithPathComponents:appendedAudioPath];
//    exportSession.outputFileType = AVFileTypeAppleM4A;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        
//        BOOL success = NO;
//        // exported successfully?
//        switch (exportSession.status) {
//            case AVAssetExportSessionStatusFailed:
//                break;
//            case AVAssetExportSessionStatusCompleted: {
//                success = YES;
//                
//                break;
//            }
//            case AVAssetExportSessionStatusWaiting:
//                break;
//            default:
//                break;
//        }
//        
//        if (handler) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                handler(success, exportSession.outputURL);
//            });
//        }
//    }];
//}
//
//- (void) clearContentsOfDirectory:(NSString*)directory
//{
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSError *error = nil;
//    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
//        [fm removeItemAtURL:[NSURL fileURLWithPathComponents:@[directory, file]] error:&error];
//    }
//}
//
//@end
