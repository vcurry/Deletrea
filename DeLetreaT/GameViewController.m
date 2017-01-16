//
//  GameViewController.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 24/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "GameViewController.h"
#import "Scene00.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsPhysics=YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    Scene00 *scene = [Scene00 sceneWithSize:CGSizeMake(1024, 768)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
