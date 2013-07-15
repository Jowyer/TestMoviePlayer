//
//  ViewController.m
//  TestMoviePlayer
//
//  Created by Wang Jowyer on 13-7-13.
//  Copyright (c) 2013年 Aruba Studio. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Tap" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 20, 100, 50);
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSString *resourceName = [NSString stringWithFormat:@"DealerMovie%d_%d", 0, 4];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"];
    timeStampDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"mp4"];
    NSURL *movieUrl = [NSURL fileURLWithPath:moviePath];
    
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    
    if (moviePlayer != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoHasFinishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        NSLog(@"Successfully instantiated the movie player.");
        
        moviePlayer.scalingMode = MPMovieScalingModeFill;
        moviePlayer.view.frame = CGRectMake(0, 0, 90, 90);
        moviePlayer.view.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        [self.view addSubview:moviePlayer.view];
        
        moviePlayer.shouldAutoplay = NO;
        moviePlayer.controlStyle = MPMovieControlStyleNone;
        [moviePlayer setFullscreen:NO animated:NO];
        [moviePlayer prepareToPlay];
    }
    else
    {
        NSLog(@"Failed to instantiate the movie player.");
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playLoopVideo];
}

#pragma mark- Public Methods
-(void)playLoopVideo
{
    [self playVideoWithIndex:0];
}

-(void)playReceiveTipsVideo
{
    [self playVideoWithIndex:1];
}

-(void)playVIPEnterVideo
{
    [self playVideoWithIndex:2];
}

#pragma mark- Private Methods
-(void)buttonTapped
{
    //fps = 25, interval = 0.04s
//    [self playVideoWithStartTime:33.84 Duration:2.6];
    [self playVideoWithIndex:13];
}

-(float)getStartTimeOfAction:(int)actionIndex
{
    NSString *keyString = [NSString stringWithFormat:@"start%d", actionIndex];
    return [[timeStampDic objectForKey:keyString] floatValue];
}

-(float)getDurationOfAction:(int)actionIndex
{
    NSString *keyString = [NSString stringWithFormat:@"duration%d", actionIndex];
    return [[timeStampDic objectForKey:keyString] floatValue];
}

- (void)playVideoWithIndex:(int)actionIndex
{
    [moviePlayer pause];
    if (actionTimer)
    {
        [actionTimer invalidate];
        actionTimer = nil;
    }
    moviePlayer.currentPlaybackTime = [self getStartTimeOfAction:actionIndex];
    [moviePlayer play];
    actionTimer = [NSTimer scheduledTimerWithTimeInterval:[self getDurationOfAction:actionIndex] target:self selector:@selector(playLoopVideo) userInfo:nil repeats:NO];
    NSLog(@"\nstart %f\nduration %f", [self getStartTimeOfAction:actionIndex], [self getDurationOfAction:actionIndex]);
}

#pragma mark- Old Methods
- (void)playVideoWithStartTime:(float)startTime Duration:(float)duration
{
    [moviePlayer pause];
    if (actionTimer)
    {
        [actionTimer invalidate];
        actionTimer = nil;
    }
    moviePlayer.currentPlaybackTime = startTime;
    [moviePlayer play];
    actionTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(playLoopVideoOld) userInfo:nil repeats:NO];
}

-(void)playLoopVideoOld
{
    [self playVideoWithStartTime:0 Duration:2.16];
}

#pragma mark- Notification Methods
- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification
{
    NSNumber *reason = [paramNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil)
    {
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger)
        {
            case MPMovieFinishReasonPlaybackEnded:
            {
                break;
            }
            case MPMovieFinishReasonPlaybackError:
            {
                break;
            }
            case MPMovieFinishReasonUserExited:
            {
                break;
            }
        }
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
    }
}

@end
