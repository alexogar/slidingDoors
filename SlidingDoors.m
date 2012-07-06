//
// Created by alexogar on 7/5/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "SlidingDoors.h"
#import "TopViewController.h"


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


- (id)init {
    self = [super init];
    if (self) {
        _duration = 0.3;
        _state = DoorsOpened;
    }

    return self;
}

- (void)toggle {

    if (_state == DoorsClosed) {


        [UIView animateWithDuration:_duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            _topController.view.frame = CGRectMake(0, -_topController.view.frame.size.height + _topOffset, _topController.view.frame.size.width, _topController.view.frame.size.height);
        }];
        _state = DoorsOpened;
    } else {
        [UIView animateWithDuration:_duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            _topController.view.frame = CGRectMake(0, 0, _topController.view.frame.size.width, _topController.view.frame.size.height);
        }];
        _state = DoorsClosed;
    }
}
@end