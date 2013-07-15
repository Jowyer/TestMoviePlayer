//
//  ViewController.h
//  TestMoviePlayer
//
//  Created by Wang Jowyer on 13-7-13.
//  Copyright (c) 2013年 Aruba Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController
{
    NSTimer *actionTimer;
    MPMoviePlayerController *moviePlayer;
    NSDictionary *timeStampDic;
}

@end
