//
//  MDEmptyDataSetPlaceholderView.m
//  BBLiveBase
//
//  Created by 徐林峰 on 2017/7/4.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <objc/runtime.h>

#import "MDEmptyDataSetPlaceholderView.h"

@interface _MDEmptyDataSetPlaceholderViewButton : UIButton
@end
@implementation _MDEmptyDataSetPlaceholderViewButton

- (CGSize)intrinsicContentSize {
    NSString *title = [self titleForState:[self state]];
    CGSize contentSize = [title sizeWithAttributes:@{NSFontAttributeName: [[self titleLabel] font]}];
    contentSize.width += 45 * 2;
    contentSize.height += (6.5 * 2 + 4);
    return contentSize;
}

@end

@interface _MDEmptyDataSetPlaceholderOffsetView : UIView
@end
@implementation _MDEmptyDataSetPlaceholderOffsetView
@end

@interface MDEmptyDataSetPlaceholderView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray<UIView *> *mutableItemViews;

@end

@interface UIView (MDEmptyDataSetPlaceholderViewOffset)

@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewOffset;
@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewContentHeight;
@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewContentWidth;

@end

@implementation UIView (MDEmptyDataSetPlaceholderViewOffset)

- (CGFloat)emptyDataSetPlaceholderViewOffset {
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewOffset)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewOffset:(CGFloat)emptyDataSetPlaceholderViewOffset {
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewOffset), @(emptyDataSetPlaceholderViewOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)emptyDataSetPlaceholderViewContentHeight {
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentHeight)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewContentHeight:(CGFloat)emptyDataSetPlaceholderViewContentHeight {
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentHeight), @(emptyDataSetPlaceholderViewContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)emptyDataSetPlaceholderViewContentWidth {
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentWidth)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewContentWidth:(CGFloat)emptyDataSetPlaceholderViewContentWidth {
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentWidth), @(emptyDataSetPlaceholderViewContentWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation MDEmptyDataSetPlaceholderView

+ (instancetype)placeholder {
    return [self placeholderWithImage:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image {
    return [self placeholderWithImage:image title:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title {
    return [self placeholderWithImage:image title:title subtitle:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    return [self placeholderWithImage:image title:title subtitle:subtitle buttonTitle:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle {
    return [[self alloc] initWithImage:image title:title subtitle:subtitle buttonTitle:buttonTitle];
}

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithImage:image title:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    return [self initWithImage:image title:title subtitle:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    return [self initWithImage:image title:title subtitle:subtitle buttonTitle:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle {
    if (self = [self init]) {
        if (image) {
            [self appendImage:image completion:nil];
        }
        if (title) {
            [self appendTitle:title completion:nil];
        }
        if (subtitle) {
            [self appendSubTitle:subtitle completion:nil];
        }
        if (buttonTitle) {
            [self appendButtonWithTitle:buttonTitle completion:nil];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
    }
    return self;
}

- (void)appendImage:(UIImage *)image completion:(void (^)(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    UIImageView *imageView = [self defaultImageView];
    imageView.image = image;

    [self _appendFreeView:imageView offset:10 completion:(id)completion];
}

- (void)appendTitle:(NSString *)title completion:(void (^)(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    UILabel *titleLabel = [self defaultTitleLabel];
    titleLabel.text = title;

    [self _appendFreeView:titleLabel offset:9 completion:(id)completion];
}

- (void)appendSubTitle:(NSString *)subtitle completion:(void (^)(UILabel *subtitleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    UILabel *subtitleLabel = [self defaultSubtitleLabel];
    subtitleLabel.text = subtitle;

    [self _appendFreeView:subtitleLabel offset:4 completion:(id)completion];
}

- (void)appendButtonWithTitle:(NSString *)title completion:(void (^)(UIButton *button, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    UIButton *button = [self defaultButton];
    [button setTitle:title forState:UIControlStateNormal];

    [self _appendFreeView:button offset:10 completion:(id)completion];
}

- (void)appendSeparatorWithBackgroundColor:(UIColor *)backgroundColor completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    UIView *view = [self defaultView];
    view.backgroundColor = backgroundColor;

    [self _appendView:view offset:10 completion:(id)completion];
}

- (void)appendView:(UIView *)view completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    [self _appendFreeView:view offset:0 completion:completion];
}

- (void)_appendFreeView:(UIView *)view offset:(CGFloat)offset completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    [self _appendView:view offset:offset completion:^(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width) {
        if (completion) completion(view, offset, height, width);
    }];
}

- (void)_appendView:(UIView *)view offset:(CGFloat)offset completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion {
    CGFloat contentHeight = -1;
    CGFloat contentWidth = -1;
    if (completion) {
        completion(view, &offset, &contentHeight, &contentWidth);
    }
    view.emptyDataSetPlaceholderViewOffset = offset;
    view.emptyDataSetPlaceholderViewContentHeight = contentHeight;
    view.emptyDataSetPlaceholderViewContentWidth = contentWidth;

    [[self contentView] addSubview:view];
    [[self mutableItemViews] addObject:view];

    [self _updateItemViewsLayout];
}

#pragma mark - accessor

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;

    [self _updateContentViewLayout];
}

- (UIImageView *)defaultImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UILabel *)defaultTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    return titleLabel;
}

- (UILabel *)defaultSubtitleLabel {
    UILabel *subtitleLabel = [UILabel new];
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    return subtitleLabel;
}

- (UIButton *)defaultButton {
    UIButton *button = [_MDEmptyDataSetPlaceholderViewButton new];
    button.userInteractionEnabled = NO;
    button.layer.cornerRadius = 4.f;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.numberOfLines = 0;
    button.backgroundColor = [UIColor colorWithRed:0.98 green:0.45 blue:0.60 alpha:1.00];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return button;
}

- (UIView *)defaultView {
    UIView *defaultView = [UIView new];
    return defaultView;
}

- (_MDEmptyDataSetPlaceholderOffsetView *)defaultOffsetView {
    _MDEmptyDataSetPlaceholderOffsetView *offsetView = [_MDEmptyDataSetPlaceholderOffsetView new];
    offsetView.userInteractionEnabled = NO;
    return offsetView;
}

- (UIView *)DZNEmptyDataSetView {
    UIView *superview = self;
    while (superview && ![superview isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")]){
        superview = [superview superview];
    };
    return superview;
}

#pragma mark - protected

- (void)layoutSubviews {
    [super layoutSubviews];

    [self _updateContentSize];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    [self _updateContentSize];
}

#pragma mark - private

- (void)_initialize {
    self.mutableItemViews = [NSMutableArray array];

    self.contentView = [UIView new];
    [self addSubview:[self contentView]];

    self.contentInsets = UIEdgeInsetsMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
}

- (void)_updateContentViewLayout{
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.contentInsets.top != CGFLOAT_MAX || self.contentInsets.bottom != CGFLOAT_MAX) {
        if (self.contentInsets.top != CGFLOAT_MAX) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.contentInsets.top];
            [constraints addObject:constraint];
        }
        if (self.contentInsets.bottom != CGFLOAT_MAX) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.contentInsets.bottom];
            [constraints addObject:constraint];
        }
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [constraints addObject:constraint];
    }
    if (self.contentInsets.left != CGFLOAT_MAX || self.contentInsets.right != CGFLOAT_MAX) {
        if (self.contentInsets.left != CGFLOAT_MAX) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.contentInsets.left];
            [constraints addObject:constraint];
        }
        if (self.contentInsets.right != CGFLOAT_MAX) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.contentInsets.right];
            [constraints addObject:constraint];
        }
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [constraints addObject:constraint];
    }
    [self removeConstraints:[[self constraints] copy]];
    [self addConstraints:constraints];
}

- (void)_updateItemViewsLayout {
    NSArray<UIView *> *itemViews = [[self mutableItemViews] copy];
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    [itemViews enumerateObjectsUsingBlock:^(UIView *itemView, NSUInteger index, BOOL *stop) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [constraints addObject:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [constraints addObject:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [constraints addObject:constraint];

        CGFloat offset = [itemView emptyDataSetPlaceholderViewOffset];
        if (!index) {
            constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
            [constraints addObject:constraint];
        } else {
            UIView *previousItemView = itemViews[index - 1];
            constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousItemView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:offset];
            [constraints addObject:constraint];
        }
        if (index == [itemViews count] - 1) {
            constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [constraints addObject:constraint];
        }

        if (itemView.emptyDataSetPlaceholderViewContentHeight > 0) {
            constraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:itemView.emptyDataSetPlaceholderViewContentHeight];
            [itemView addConstraint:constraint];
        }
    }];

    [[self contentView] removeConstraints:[[[self contentView] constraints] copy]];
    [[self contentView] addConstraints:constraints];
}

- (void)_updateContentSize {
    UIView *DZNEmptyDataSetView = [self DZNEmptyDataSetView];
    if (!DZNEmptyDataSetView) return;

    CGSize size = DZNEmptyDataSetView.bounds.size;
    NSMutableArray *constraints = [NSMutableArray array];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:size.height];
    [constraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:size.width];
    [constraints addObject:constraint];

    [self addConstraints:constraints];
}

@end
