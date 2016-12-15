//
//  OSAudioPlayerView.m
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "OSAudioPlayerView.h"
#import "UIView+LayoutConstraints.h"
#import "OSAudioTableViewCell.h"
#import "OSAudioManager.h"

@interface OSAudioPlayerView () <UITableViewDelegate, UITableViewDataSource, OSAudioTableViewCellDelegate>

@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) NSIndexPath *currentlyPlayingCellIndexPath;

@end

@implementation OSAudioPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)initSubViews
{
    self.audioFilesURLArray = [NSMutableArray new];
    self.tableViewHeight = 1.0f;
    self.playerTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.playerTableView.delegate = self;
    self.playerTableView.dataSource = self;
    [self.playerTableView registerNib:[UINib nibWithNibName:@"OSAudioTableViewCell" bundle:nil] forCellReuseIdentifier:@"OSAudioTableViewCell"];
    [self addSubview:self.playerTableView];
}

- (void)addLayoutConstraints
{
    self.playerTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playerTableView distanceLeftToSuperview:0.0f];
    [self.playerTableView distanceTopToSuperview:0.0f];
    [self.playerTableView distanceRightToSuperview:0.0f];
    [self.playerTableView setHeightConstraint:1.0f];
}

#pragma mark - Self methods
- (void)changeTableViewHeight:(BOOL)increment
{
    self.tableViewHeight = increment ? self.tableViewHeight + 50.0f : self.tableViewHeight - 50.0f;
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.playerTableView.constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight)
        {
            heightConstraint = constraint;
            break;
        }
    }
    heightConstraint.constant = self.tableViewHeight;
    if ([self.delegate respondsToSelector:@selector(audioPlayerView:didRowNumberChanged:withTableViewHeight:)])
    {
        [self.delegate audioPlayerView:self
                   didRowNumberChanged:increment
                   withTableViewHeight:self.tableViewHeight];
    }
}

#pragma mark - UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.audioFilesURLArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSAudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OSAudioTableViewCell" forIndexPath:indexPath];
    cell.fileURL = [self.audioFilesURLArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.seekableSlider.value = cell.currentTime;
    CGFloat minutes = floor(cell.currentTime / 60);
    CGFloat seconds = cell.currentTime - (minutes * 60);
    cell.timeLabel.text = [[NSString alloc] initWithFormat:@"%02.0f:%02.0f", minutes, seconds];
    return cell;
}

#pragma mark - OSAudioTableViewCell Delegate
- (void)audioTableViewCell:(OSAudioTableViewCell *)cell
  didTappedPlayPauseButton:(AudioPlayerViewState)state
{
    if ([OSAudioManager sharedInstance].recorder.isRecording)
    {
        // recording.. do not allow play or pause actions..
        return;
    }
    // Start playing
    else if (state == AudioPlayerViewStatePlaying)
    {
        // Add observers
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateTimeLabel:)
                                                     name:timerTicked
                                                   object:[OSAudioManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managerDidFinishPlaying:)
                                                     name:playingFinished
                                                   object:[OSAudioManager sharedInstance]];
        
        [[OSAudioManager sharedInstance] prepareToPlay:cell.fileURL
                                        withPauseStart:(cell.pauseStart && cell.previousFireDate) ? cell.pauseStart : nil
                                  withPreviousFireDate:(cell.pauseStart && cell.previousFireDate) ? cell.previousFireDate : nil
                                       withCurrentTime:cell.currentTime];
        self.currentlyPlayingCellIndexPath = [self.playerTableView indexPathForCell:cell];
        cell.seekableSlider.maximumValue = [OSAudioManager sharedInstance].player.duration;
        [cell.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pause"]
                                        forState:UIControlStateNormal];
        [[OSAudioManager sharedInstance] startPlaying];
    }
    // Pause playing
    else if (state == AudioPlayerViewStateWaiting)
    {
        // Remove observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:timerTicked
                                                      object:[OSAudioManager sharedInstance]];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:playingFinished
                                                      object:[OSAudioManager sharedInstance]];
        
        self.currentlyPlayingCellIndexPath = nil;
        cell.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
        cell.previousFireDate = [[OSAudioManager sharedInstance].timer fireDate];
        cell.currentTime = [OSAudioManager sharedInstance].player.currentTime;
        [cell.playPauseButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                        forState:UIControlStateNormal];
        [[OSAudioManager sharedInstance] pausePlaying];
        
    }
}

- (void)audioTableViewCell:(OSAudioTableViewCell *)cell
     didTappedDeleteButton:(NSURL *)fileURL
{
    [[OSAudioManager sharedInstance] pausePlaying];
    [[OSAudioManager sharedInstance] removeFile:cell.fileURL.absoluteString];
    for (NSURL *url in self.audioFilesURLArray)
    {
        if (url.absoluteString == fileURL.absoluteString)
        {
            [self.audioFilesURLArray removeObjectAtIndex:[self.audioFilesURLArray indexOfObject:url]];
            break;
        }
    }
    [self.playerTableView reloadData];
    [self changeTableViewHeight:NO];
}

- (void)audioTableViewCell:(OSAudioTableViewCell *)cell
        sliderValueChanged:(UISlider *)slider
{
    cell.currentTime = slider.value;
    CGFloat minutes = floor(slider.value / 60);
    CGFloat seconds = slider.value - (minutes * 60);
    cell.timeLabel.text = [[NSString alloc] initWithFormat:@"%02.0f:%02.0f", minutes, seconds];
    if ([OSAudioManager sharedInstance].player.isPlaying)
    {
        [OSAudioManager sharedInstance].player.currentTime = slider.value;
    }
}

#pragma mark - Notifications
- (void)updateTimeLabel:(NSNotification *)notification
{
    OSAudioTableViewCell *cell = [self.playerTableView cellForRowAtIndexPath:self.currentlyPlayingCellIndexPath];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"time"]];
    cell.seekableSlider.value = [OSAudioManager sharedInstance].player.currentTime;
}

- (void)managerDidFinishPlaying:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:timerTicked
                                                  object:[OSAudioManager sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:playingFinished
                                                  object:[OSAudioManager sharedInstance]];
    OSAudioTableViewCell *cell = [self.playerTableView cellForRowAtIndexPath:self.currentlyPlayingCellIndexPath];
    [cell showInitialState];
}

@end
