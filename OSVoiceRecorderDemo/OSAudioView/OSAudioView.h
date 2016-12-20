//
//  OSAudioView.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 14/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSAudioRecorderView.h"
#import "OSAudioPlayerView.h"

@interface OSAudioView : UIView

@property (nonatomic, strong) OSAudioRecorderView   *recorderView;
@property (nonatomic, strong) OSAudioPlayerView     *playerView;

@property (nonatomic, strong) UIViewController      *parentViewController;


@property (nonatomic, strong) NSMutableArray        *recordURLsArray;

- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController;

@end
