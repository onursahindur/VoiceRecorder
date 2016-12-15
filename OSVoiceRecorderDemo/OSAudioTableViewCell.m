//
//  OSAudioTableViewCell.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioTableViewCell.h"

@interface OSAudioTableViewCell ()

@end

@implementation OSAudioTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSURL *)fileURL
{
    self.fileURL = fileURL;
}

- (void)showInitialState
{
    self.timeLabel.text = @"00:00";
    self.seekableSlider.value = 0.0f;
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"voice_record_play"]
                                    forState:UIControlStateNormal];
    self.state = AudioPlayerViewStateWaiting;
    self.currentTime = 0;
    self.previousFireDate = nil;
    self.pauseStart = nil;
}

#pragma mark - Actions
- (IBAction)deleteButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(audioTableViewCell:didTappedDeleteButton:)])
    {
        [self.delegate audioTableViewCell:self didTappedDeleteButton:self.fileURL];
    }
}

- (IBAction)playPauseButtonTapped:(id)sender
{
    // State wating prepare for start
    if (self.state == AudioPlayerViewStateWaiting)
    {
        self.state = AudioPlayerViewStatePlaying;
    }
    // State playing, prepare for pause
    else if (self.state == AudioPlayerViewStatePlaying)
    {
        self.state = AudioPlayerViewStateWaiting;
    }
    if ([self.delegate respondsToSelector:@selector(audioTableViewCell:didTappedPlayPauseButton:)])
    {
        [self.delegate audioTableViewCell:self didTappedPlayPauseButton:self.state];
    }
}

- (IBAction)sliderValueChanged:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(audioTableViewCell:sliderValueChanged:)])
    {
        [self.delegate audioTableViewCell:self sliderValueChanged:(UISlider *)sender];
    }
}

@end
