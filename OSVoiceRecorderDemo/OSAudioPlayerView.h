//
//  OSAudioPlayerView.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSAudioPlayerView;
@protocol OSAudioPlayerViewDelegate <NSObject>

- (void)audioPlayerView:(OSAudioPlayerView *)view
    didRowNumberChanged:(BOOL)addedRow
    withTableViewHeight:(CGFloat)height;

@end

@interface OSAudioPlayerView : UIView

@property (nonatomic, strong) UITableView       *playerTableView;
@property (nonatomic, strong) NSMutableArray    *audioFilesURLArray;

@property (nonatomic, weak) id <OSAudioPlayerViewDelegate> delegate;

- (void)changeTableViewHeight:(BOOL)increment;

@end
