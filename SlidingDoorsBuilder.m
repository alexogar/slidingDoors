//
// Created by alexogar on 7/5/12.
//


#import <CoreGraphics/CoreGraphics.h>
#import "SlidingDoorsBuilder.h"
#import "TopViewController.h"

@implementation SlidingDoorsBuilder {
    SlidingDoors *instance;
}

- (id)init {
    self = [super init];
    if (self) {
        instance = [[SlidingDoors alloc] init];
    }

    return self;
}


+ (id)builder {
    return [[SlidingDoorsBuilder alloc] init];
}

- (SlidingDoorsBuilder *)withOrientation:(SlidingDoorsOrientation)orientation {
    instance.orientation = orientation;
    return self;
}

- (SlidingDoorsBuilder *)withQuantityOfTop:(NSInteger)firstQuant toBottom:(NSInteger)secondQuant {
    //lets calculate here the quantity to percents
    instance.topSize = firstQuant;
    instance.bottomSize = secondQuant;
    return self;
}

- (SlidingDoorsBuilder *)withTopController:(UIViewController <SlideDoorProtocol> *)controller {
    instance.topController = controller;
    return self;
}

- (SlidingDoorsBuilder *)withTopController:(UIViewController<SlideDoorProtocol> *)controller withOffset:(NSInteger) topOffset {
    [self withTopController:controller];
    instance.topOffset = topOffset;
    return self;
}

- (SlidingDoorsBuilder *)withBottomController:(UIViewController<SlideDoorProtocol> *)controller {
    instance.bottomController = controller;
    return self;
}

- (SlidingDoorsBuilder *)withBottomController:(UIViewController<SlideDoorProtocol> *)controller withOffset:(NSInteger) bottomOffset {
    [self withBottomController:controller];
    instance.bottomOffset = bottomOffset;
    return self;
}

- (SlidingDoorsBuilder *)withSlideDuration:(NSTimeInterval)duration {
    instance.duration = duration;
    return self;
}

- (SlidingDoorsBuilder *)withParentView:(UIView *)parentView {
    instance.parentView = parentView;
    return self;
}


- (SlidingDoors *)build {
    //Validate
    if (instance.parentView == nil) {
        @throw([NSException exceptionWithName:@"WrongConfigParam" reason:@"parentView is not defined" userInfo:nil]);
    }

    if (instance.topController != nil) {
        //Lets put it`s view into place
        [instance.parentView addSubview:instance.topController.view];
        CGRect frame = instance.topController.view.frame;
        instance.topController.view.frame = CGRectMake(0,-frame.size.height+instance.topOffset, frame.size.width, frame.size.height);
    }

    return instance;
}
@end