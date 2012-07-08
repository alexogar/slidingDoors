//
// Created by alexogar on 7/5/12.
//


#import <Foundation/Foundation.h>
#import "SlidingDoors.h"
#import "SlideDoorProtocol.h"

typedef enum {
    HorizontalDoorsOrientation = 0,                  // horizontal doors like in lift
    VerticalDoorsOrientation                 // vertical like navigation control
} SlidingDoorsOrientation;

typedef enum {
    DoorsClosed,
    DoorsOpened,
    DoorsInDrag,
    DoorsInAnimation
} SlidingDoorsState;

@class SlidingDoors;

@protocol MovementStrategy<NSObject>
-(id)initWithDoors:(SlidingDoors *)doors;
-(CGRect)firstDoorOpenedRect:(UIView *)firstView;
-(CGRect)firstDoorClosedRect:(UIView *)firstView;
-(CGRect)addDirectionDifference:(CGFloat) difference toFirstDoor:(UIView *)firstView;
-(SlidingDoorsState)closestStateForFirst:(UIView *)firstView;
-(CGFloat)currentPercentForFirst:(UIView *)firstView;

-(CGRect)secondDoorOpenedRect:(UIView *)secondView;
-(CGRect)secondDoorClosedRect:(UIView *)secondView;
-(CGRect)addDirectionDifference:(CGFloat) difference toSecondDoor:(UIView *)secondView;
-(SlidingDoorsState)closestStateForSecond:(UIView *)secondView;
-(CGFloat)currentPercentForSecond:(UIView *)secondView;

-(CGFloat)calculateDirectionDifference:(CGPoint) start and:(CGPoint) end;
@end

@interface VerticalStrategy : NSObject <MovementStrategy>
@end

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
@property(nonatomic, strong) NSObject<MovementStrategy> *strategy;

- (void)toggle;
- (void)close;
- (void)closeWithDuration:(NSTimeInterval) closeDuration;
- (void)open;
- (void)openWithDuration:(NSTimeInterval) openDuration;
- (void)moveToDifference:(CGFloat)aFloat;

- (IBAction)dragSupport:(UIGestureRecognizer *)sender;
@end