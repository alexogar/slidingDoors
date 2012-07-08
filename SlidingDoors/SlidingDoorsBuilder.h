//
// Created by alexogar on 7/5/12.
//


#import <Foundation/Foundation.h>
#import "SlidingDoors.h"
#import "SlideDoorProtocol.h"

@interface SlidingDoorsBuilder : NSObject
+(id)builder;

- (SlidingDoorsBuilder *)withOrientation:(SlidingDoorsOrientation) orientation;
- (SlidingDoorsBuilder *)withQuantityOfTop:(NSInteger) firstQuant toBottom:(NSInteger) secondQuant;

- (SlidingDoorsBuilder *)withTopController:(UIViewController<SlideDoorProtocol> *)controller;
- (SlidingDoorsBuilder *)withTopController:(UIViewController<SlideDoorProtocol> *)controller withOffset:(NSInteger) topOffset;
- (SlidingDoorsBuilder *)withBottomController:(UIViewController<SlideDoorProtocol> *)controller;
- (SlidingDoorsBuilder *)withBottomController:(UIViewController<SlideDoorProtocol> *)controller withOffset:(NSInteger) bottomOffset;

- (SlidingDoorsBuilder *)withSlideDuration:(NSTimeInterval) duration;

- (SlidingDoorsBuilder *)withParentView:(UIView *)parentView;
- (SlidingDoorsBuilder *)withDragSupport:(UIView *)dragTarget;

- (bool)validate;
- (SlidingDoors *)build;

@end