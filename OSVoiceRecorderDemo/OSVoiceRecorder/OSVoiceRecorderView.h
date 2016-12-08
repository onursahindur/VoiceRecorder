//
//  OSVoiceRecorderView.h
//  OSVoiceRecorder
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class OSVoiceRecorderView;
@protocol OSVoiceRecorderViewDelegate <NSObject>

- (void)voiceRecorderViewDidTappedRecordButton;
- (void)voiceRecorderViewDidTappedStopRecordButton;
- (void)voiceRecorderViewDidTappedPlayRecordButton;
- (void)voiceRecorderViewDidTappedPauseRecordButton;
- (void)voiceRecorderSliderDidChange:(CGFloat)value;

@end

@interface OSVoiceRecorderView : UIView

@property (nonatomic, weak) id <OSVoiceRecorderViewDelegate> delegate;

- (void)showPlayView;
- (void)showInitialPlayState;
- (void)updateRecordTimeLabel:(NSString *)timeString;
- (void)updatePlayTimeLabel:(NSString *)timeString;
- (void)updateSliderValue:(CGFloat)duration;
- (void)setSliderMaximumValue:(CGFloat)value;

@end
