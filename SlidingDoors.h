//
// Created by alexogar on 7/5/12.
//


#import <Foundation/Foundation.h>
#import "SlidingDoors.h"
#import "SlideDoorProtocol.h"

typedef enum {
    HorizontalDoorsOrientation,                  // horizontal doors like in lift
    VerticalDoorsOrientation                 // vertical like navigation control
} SlidingDoorsOrientation;

typedef enum {
    DoorsClosed,
    DoorsOpened
} SlidingDoorsState;

@interface SlidingDoors : NSObject

@property(nonatomic, assign) SlidingDoorsOrientation orientation;
@property(nonatomic, assign) NSInteger bottomSize;
@property(nonatomic, assign) NSInteger topSize;
@property(nonatomic, strong) UIViewController <SlideDoorProtocol> *topController;
@property(nonatomic, strong) UIViewController <SlideDoorProtocol> *bottomController;
@property(nonatomic, strong) UIView *parentView;
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) SlidingDoorsState state;

@property(nonatomic, assign) NSInteger topOffset;

@property(nonatomic, assign) NSInteger bottomOffset;

- (void)toggle;
@end