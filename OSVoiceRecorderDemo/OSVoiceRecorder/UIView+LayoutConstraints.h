//
//  UIView+LayoutConstraints.h
//  Carbon
//
//  Created by Onur Şahindur on 12/01/15.
//  Copyright (c) 2015 onursahindur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(LayoutConstraints)

/**
 Adds a layout constraint between the left of the view and the right of the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distance:(CGFloat)distance toLeftView:(UIView *)view;

/**
 Adds a layout constraint between the left of the view and the left of the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distanceLeftToSuperview:(CGFloat)distance;

/**
 Adds a layout constraint between the right of the view and the left of the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distance:(CGFloat)distance toRightView:(UIView *)view;

/**
 Adds a layout constraint between the right of the view and the right of the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distanceRightToSuperview:(CGFloat)distance;

/**
 Adds a layout constraint between the top of the view and the bottom of the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distance:(CGFloat)distance toTopView:(UIView *)view;

/**
 Adds a layout constraint between the top of the view and the top of the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distanceTopToSuperview:(CGFloat)distance;

/**
 Adds a layout constraint between the bottom of the view and the top of the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distance:(CGFloat)distance toBottomView:(UIView*)view;

/**
 Adds a layout constraint between the bottom of the view and the bottom of the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)distanceBottomToSuperview:(CGFloat)distance;

/**
 Adds a height layout constraint to the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)setHeightConstraint:(CGFloat)height;

/**
 Adds a width layout constraint to the given view.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)setWidthConstraint:(CGFloat)width;

/**
 Centers the view in the x-axis within its superview. Adds the constraint to the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)centerXInSuperview;

/**
 Centers the view in the y-axis within its superview. Adds the constraint to the superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)centerYInSuperview;

/**
 Adds a constraint that makes the width of the view equal to its superview.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)equalWidthWithSuperView:(UIView *)superview;

/**
 Adds a constraint that makes the width of the view equal to the width of the superview times a factor.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)equalWidthWithSuperView:(UIView *)superview multiplier:(CGFloat)multiplier;

/**
 Adds a constraint that makes the height of the view equal to its superview.
 @param multiplier Multiplier for the NSLayoutConstraint object.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)equalHeightWithSuperView:(UIView *)superview;

/**
 Adds a constraint that makes the width of the view equal to the height of the superview times a factor.
 @param multiplier Multiplier for the NSLayoutConstraint object.
 @return The layout constraint created by this method.
 */
- (NSLayoutConstraint *)equalHeightWithSuperView:(UIView *)superview multiplier:(CGFloat)multiplier;

/**
 Adds an aspect ratio constraint.
 @param ratio Multiplier for the layout constraint. It should be given as width/height;
 */
- (NSLayoutConstraint *)setAspectRatioConstraint:(CGFloat)ratio;

@end
