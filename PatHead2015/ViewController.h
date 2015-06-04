//
//  ViewController.h
//  PatHead2015
//
//  Created by Eric Hayes on 6/3/15.
//  Copyright (c) 2015 Brewmium, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UILabel *timeTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreTitle;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *withLove;
@property (strong, nonatomic) IBOutlet UIView *gameboard;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *life1;
@property (strong, nonatomic) IBOutlet UIImageView *life2;
@property (strong, nonatomic) IBOutlet UIImageView *life3;

@end

