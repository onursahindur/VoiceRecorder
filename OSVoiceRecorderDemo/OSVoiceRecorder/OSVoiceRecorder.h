//
//  OSVoiceRecorder.h
//  OSVoiceRecorderDemo
//
//  Created by Onur Şahindur on 07/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OSVoiceRecorderView.h"

@interface OSVoiceRecorder : NSObject

- (instancetype)initDefault;

- (OSVoiceRecorderView *)addRecordViewToView:(UIView *)view
                                   withFrame:(CGRect)frame
                     withViewController:(UIViewController *)viewController;

@property (nonatomic, assign) BOOL recorded;
@property (nonatomic, strong) OSVoiceRecorderView *recorderView;

@end
