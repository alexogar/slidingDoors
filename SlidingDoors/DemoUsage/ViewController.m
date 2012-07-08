//
//  ViewController.m
//  timer
//
//  Created by Alexey Ogarkov on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SlidingDoorsBuilder.h"
#import "TopViewController.h"
#import "BottomViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    SlidingDoors *_doors;
    SlidingDoorsBuilder *_builder;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TopViewController *topViewController = [[TopViewController alloc] init];
    BottomViewController *bottomViewController = [[BottomViewController alloc] init];

    _builder = [SlidingDoorsBuilder builder];
    [_builder withQuantityOfTop:40 toBottom:60];
    [_builder withTopController: topViewController withOffset:40];
    [_builder withBottomController:bottomViewController];
    [_builder withParentView: self.view];
    [_builder withSlideDuration:0.3];
    [_builder withDragSupport:topViewController.view];

    _doors = [_builder build];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)launchSlides:(id)sender {
    [_doors toggle];
}
@end