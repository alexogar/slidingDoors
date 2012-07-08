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

- (SlidingDoorsBuilder *)withTopController:(UIViewController <SlideDoorProtocol> *)controller withOffset:(NSInteger)topOffset {
    [self withTopController:controller];
    instance.topOffset = topOffset;
    return self;
}

- (SlidingDoorsBuilder *)withBottomController:(UIViewController <SlideDoorProtocol> *)controller {
    instance.bottomController = controller;
    return self;
}

- (SlidingDoorsBuilder *)withBottomController:(UIViewController <SlideDoorProtocol> *)controller withOffset:(NSInteger)bottomOffset {
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

- (SlidingDoorsBuilder *)withDragSupport:(UIView *)dragTarget {

    UIPanGestureRecognizer *topPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:instance action:@selector(dragSupport:)];

    [dragTarget addGestureRecognizer:topPanGestureRecognizer];


    return self;
}


- (void)buildInstance {
    if (instance.orientation == -1) {
        instance.orientation = VerticalDoorsOrientation;
    }

    if (instance.orientation != -1) {
        switch (instance.orientation) {
            case VerticalDoorsOrientation:
                instance.strategy = [[VerticalStrategy alloc] initWithDoors:instance];
                break;
            case HorizontalDoorsOrientation:
                break;
            default:
                break;
        }
    }
}

- (bool)validate {
    if (instance.parentView == nil) {
        NSLog(@"parentView is not defined");
        return FALSE;
    }
    return TRUE;
}

- (void)prepareUI {
    if (instance.topController != nil) {
        //Lets put it`s view into place
        [instance.parentView addSubview:instance.topController.view];
        instance.topController.view.frame = [instance.strategy firstDoorClosedRect:instance.topController.view];
    }

    if (instance.bottomController != nil) {
        [instance.parentView addSubview:instance.bottomController.view];
        instance.bottomController.view.frame = [instance.strategy secondDoorClosedRect:instance.bottomController.view];

    }
}

- (SlidingDoors *)build {
    //Validate
    if (![self validate]) {
        @throw([NSException exceptionWithName:@"WrongConfigParam" reason:@"Wrong configured" userInfo:nil]);
    }

    [self buildInstance];
    [self prepareUI];


    return instance;
}
@end