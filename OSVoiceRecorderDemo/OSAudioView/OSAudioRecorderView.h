//
//  OSAudioRecorderView.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AudioRecorderViewStateWaiting,
    AudioRecorderViewStateRecording
}AudioRecorderViewState;

@protocol OSAudioRecorderViewDelegate <NSObject>

- (void)audioManagerDidFinishRecording:(NSURL *)outputURL;

@end

@interface OSAudioRecorderView : UIView

// waiting state
@property (nonatomic, strong) UIView            *waitingView;
@property (nonatomic, strong) UIImageView       *recordImageView;
@property (nonatomic, strong) UILabel           *startRecordLabel;

// recording state
@property (nonatomic, strong) UIView            *recordingView;
@property (nonatomic, strong) UIButton          *stopRecordButton;
@property (nonatomic, strong) UIView            *recordingStatusView;
@property (nonatomic, strong) UILabel           *recordingTimeLabel;

@property (nonatomic, assign) AudioRecorderViewState currentState;
@property (nonatomic, weak) id <OSAudioRecorderViewDelegate> delegate;

@property (nonatomic, assign) NSInteger recordNumber;

- (void)showRecorderState:(AudioRecorderViewState)state;

@end
