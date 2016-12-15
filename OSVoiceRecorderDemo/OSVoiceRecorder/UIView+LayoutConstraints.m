//
//  UIView+LayoutConstraints.m
//  Carbon
//
//  Created by Onur Şahindur on 12/01/15.
//  Copyright (c) 2015 onursahindur. All rights reserved.
//

#import "UIView+LayoutConstraints.h"

static CGFloat const kDefaultMultiplier = 1.0f;

@implementation UIView(LayoutConstraints)

- (NSLayoutConstraint *)distance:(CGFloat)distance toLeftView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)distanceLeftToSuperview:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)distance:(CGFloat)distance toRightView:(UIView*)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)distanceRightToSuperview:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)distance:(CGFloat)distance toTopView:(UIView*)view
{
    NSLayoutConstraint *constraint;
    
    if (view)
    {
        constraint = [NSLayoutConstraint constraintWithItem:self
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:view
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:kDefaultMultiplier
                                                   constant:distance];
        [self.superview addConstraint:constraint];
    }
    else
    {
        constraint = [self distanceTopToSuperview:distance];
    }
    
    return constraint;
}


- (NSLayoutConstraint *)distanceTopToSuperview:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)distance:(CGFloat)distance toBottomView:(UIView*)view
{
    NSLayoutConstraint *constraint;
    
    if (view)
    {
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:kDefaultMultiplier
                                                   constant:distance];
        [self.superview addConstraint:constraint];
    }
    else
    {
        constraint = [self distanceBottomToSuperview:distance];
    }
    
    return constraint;
}

- (NSLayoutConstraint *)distanceBottomToSuperview:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:distance];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)setHeightConstraint:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:height];
    [self addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)setWidthConstraint:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:kDefaultMultiplier
                                                                   constant:width];
    [self addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)centerXInSuperview {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0];
    [self.superview addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)centerYInSuperview {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.superview
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)equalWidthWithSuperView:(UIView *)superview
{
    return [self equalWidthWithSuperView:superview multiplier:kDefaultMultiplier];
}

- (NSLayoutConstraint *)equalHeightWithSuperView:(UIView *)superview
{
    return [self equalHeightWithSuperView:superview multiplier:kDefaultMultiplier];
}

- (NSLayoutConstraint *)equalHeightWithSuperView:(UIView *)superview multiplier:(CGFloat)multiplier
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superview
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:multiplier
                                                                   constant:0];
    [superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)equalWidthWithSuperView:(UIView *)superview multiplier:(CGFloat)multiplier
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superview
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:multiplier
                                                                   constant:0];
    [superview addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)setAspectRatioConstraint:(CGFloat)ratio
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self attribute:NSLayoutAttributeHeight
                                                                 multiplier:ratio
                                                                   constant:0];
    
    [self addConstraint:constraint];
    
    return constraint;
}

@end
