//
// Created by alexogar on 7/5/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "SlidingDoors.h"

@implementation VerticalStrategy {
    SlidingDoors *_doors;

}
- (id)initWithDoors:(SlidingDoors *)doors {
    self = [super init];
    if (self) {
        _doors = doors;
    }

    return self;
}

- (CGRect)firstDoorOpenedRect:(UIView *)firstView {
    return CGRectMake(0, -firstView.frame.size.height + _doors.topOffset, firstView.frame.size.width, firstView.frame.size.height);
}

- (CGRect)secondDoorOpenedRect:(UIView *)secondView {
    return CGRectMake(0, _doors.parentView.frame.size.height - _doors.bottomOffset, secondView.frame.size.width, secondView.frame.size.height);
}

- (CGRect)firstDoorClosedRect:(UIView *)firstView {
    return CGRectMake(0, 0, firstView.frame.size.width, firstView.frame.size.height);
}

- (CGRect)secondDoorClosedRect:(UIView *)secondView {
    return CGRectMake(0, _doors.parentView.frame.size.height - secondView.frame.size.height, secondView.frame.size.width, secondView.frame.size.height);
}

- (CGFloat)calculateDirectionDifference:(CGPoint)start and:(CGPoint)end {
    return end.y - start.y;
}

- (CGRect)addDirectionDifference:(CGFloat)difference toFirstDoor:(UIView *)firstView {

    CGFloat newY = firstView.frame.origin.y + difference;

    if (newY > 0 || newY < _doors.topOffset - firstView.frame.size.height) {
        return firstView.frame;
    }

    return CGRectMake(0, firstView.frame.origin.y + difference, firstView.frame.size.width, firstView.frame.size.height);
}

- (CGRect)addDirectionDifference:(CGFloat)difference toSecondDoor:(UIView *)secondView {
    CGFloat newY = secondView.frame.origin.y - difference;

    if (newY < _doors.parentView.frame.size.height - secondView.frame.size.height
            || newY > _doors.parentView.frame.size.height - _doors.bottomOffset) {
        return secondView.frame;
    }

    return CGRectMake(0, secondView.frame.origin.y - difference, secondView.frame.size.width, secondView.frame.size.height);
}

- (CGFloat)currentPercentForFirst:(UIView *)firstView {
    CGFloat currentY = firstView.frame.origin.y;
    return fabsf(currentY / (firstView.frame.size.height - _doors.topOffset));
}

- (CGFloat)currentPercentForSecond:(UIView *)secondView {
    CGFloat currentY = secondView.frame.origin.y;
    return fabsf(currentY / (_doors.parentView.frame.size.height - secondView.frame.size.height + _doors.bottomOffset));
}

- (SlidingDoorsState)closestStateForSecond:(UIView *)secondView {
    CGFloat percent = [self currentPercentForFirst:secondView];

    return percent < 0.5 ? DoorsClosed : DoorsOpened;
}

- (SlidingDoorsState)closestStateForFirst:(UIView *)firstView {
    CGFloat percent = [self currentPercentForFirst:firstView];

    return percent < 0.5 ? DoorsClosed : DoorsOpened;
}


@end


@implementation SlidingDoors {

@private
    SlidingDoorsOrientation _orientation;
    NSInteger _bottomSize;
    NSInteger _topSize;
    UIViewController <SlideDoorProtocol> *_topController;
    UIViewController <SlideDoorProtocol> *_bottomController;
    UIView *_parentView;
    NSTimeInterval _duration;
    SlidingDoorsState _state;
    NSInteger _topOffset;
    NSInteger _bottomOffset;
    NSObject <MovementStrategy> *_strategy;
    CGPoint _dragStartPoint;
}
@synthesize orientation = _orientation;
@synthesize bottomSize = _bottomSize;
@synthesize topSize = _topSize;
@synthesize topController = _topController;
@synthesize bottomController = _bottomController;
@synthesize parentView = _parentView;
@synthesize duration = _duration;
@synthesize state = _state;
@synthesize topOffset = _topOffset;
@synthesize bottomOffset = _bottomOffset;
@synthesize strategy = _strategy;


- (id)init {
    self = [super init];
    if (self) {
        _duration = 0.3;
        _state = DoorsOpened;
        _orientation = VerticalDoorsOrientation;
    }

    return self;
}

#pragma mark -- Operations

- (void)toggle {
    if (_state == DoorsClosed) {
        [self open];
    } else {
        [self close];
    }
}

- (void)close {
    [self closeWithDuration:_duration];
}

- (void)open {
    [self openWithDuration:_duration];
}

- (void)closeWithDuration:(NSTimeInterval)closeDuration {

    if (_state == DoorsClosed) {
        return;
    }

    [UIView animateWithDuration:closeDuration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (_topController != nil) {
            _topController.view.frame = [_strategy firstDoorClosedRect:_topController.view];
        }

        if (_bottomController != nil) {
            _bottomController.view.frame = [_strategy secondDoorClosedRect:_bottomController.view];
        }
    }];
    _state = DoorsClosed;
}

- (void)openWithDuration:(NSTimeInterval)openDuration {
    if (_state == DoorsOpened) {
        return;
    }

    [UIView animateWithDuration:_duration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (_topController != nil) {
            _topController.view.frame = [_strategy firstDoorOpenedRect:_topController.view];
        }

        if (_bottomController != nil) {
            _bottomController.view.frame = [_strategy secondDoorOpenedRect:_bottomController.view];
        }
    }];
    _state = DoorsOpened;
}

- (void)moveToDifference:(CGFloat)difference {
    if (_topController != nil) {
        _topController.view.frame = [_strategy addDirectionDifference:difference toFirstDoor:_topController.view];
    }

    if (_bottomController != nil) {
        _bottomController.view.frame = [_strategy addDirectionDifference:difference toSecondDoor:_bottomController.view];
    }
}

- (void)moveToClosest {
    if (_topController != nil) {
        CGFloat percent = [_strategy currentPercentForFirst:_topController.view];
        SlidingDoorsState futureState = [_strategy closestStateForFirst:_topController.view];
        if (futureState == DoorsOpened) {
            [self openWithDuration:_duration * percent];
        } else if (futureState == DoorsClosed) {
            [self closeWithDuration:_duration * percent];
        }
    }
}

#pragma mark -- Drag and Drop


- (IBAction)dragSupport:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _dragStartPoint = [sender locationInView:_parentView];
            _state = DoorsInDrag;
            break;
        case UIGestureRecognizerStateChanged: {

            if (_state != DoorsInDrag) {
                break;
            }

            CGPoint newStatePoint = [sender locationInView:_parentView];
            CGFloat difference = [_strategy calculateDirectionDifference:_dragStartPoint and:newStatePoint];
            [self moveToDifference:difference];
            _dragStartPoint = newStatePoint;

            break;
        }
        default:
            _state = DoorsInAnimation;
            [self moveToClosest];
            break;
    }
}

@end