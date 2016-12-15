//
//  OSAudioTableViewCell.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AudioPlayerViewStateWaiting,
    AudioPlayerViewStatePlaying
}AudioPlayerViewState;

@class OSAudioTableViewCell;
@protocol OSAudioTableViewCellDelegate <NSObject>

- (void)audioTableViewCell:(OSAudioTableViewCell *)cell didTappedPlayPauseButton:(AudioPlayerViewState)state;
- (void)audioTableViewCell:(OSAudioTableViewCell *)cell sliderValueChanged:(UISlider *)slider;
- (void)audioTableViewCell:(OSAudioTableViewCell *)cell didTappedDeleteButton:(NSURL *)fileURL;

@end

@interface OSAudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton   *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider   *seekableSlider;
@property (weak, nonatomic) IBOutlet UILabel    *timeLabel;

@property (strong, nonatomic) NSDate                *pauseStart;
@property (strong, nonatomic) NSDate                *previousFireDate;
@property (assign, nonatomic) NSTimeInterval        currentTime;
@property (strong, nonatomic) NSURL                 *fileURL;
@property (assign, nonatomic) AudioPlayerViewState  state;

@property (weak, nonatomic) id <OSAudioTableViewCellDelegate> delegate;

- (void)configureCell:(NSURL *)fileURL;
- (void)showInitialState;

@end
