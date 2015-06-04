//
//  ViewController.m
//  PatHead2015
//
//  Created by Eric Hayes on 6/3/15.
//  Copyright (c) 2015 Brewmium, LLC. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+brewmium.h"

#define kPathead @"pathead1.png"
#define kPathead2 @"pathead2.png"

#define kSpeedMin 5
#define kSpeedMax 100
#define kSpeedAdjust 2
#define kNewHeadHoldoff 50
#define kGameDuration 60

@interface ViewController () {
	BOOL once;
	NSTimer *timer;
	UIView *patheadContainer;
	UIImageView *pathead;
	BOOL running;
	CGRect gameRect;
	NSInteger lives;
	NSInteger score;
	NSInteger speed;
	NSInteger moveTime;
	NSInteger holdoff;
	NSInteger time;
	UITapGestureRecognizer *tap;
	UITapGestureRecognizer *miss;
	AVAudioPlayer *beep;
	AVAudioPlayer *fail;
}

@end


@implementation ViewController


- (UIColor *)getExtraDarkGrayColor;
{
	return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255 alpha:1.0];
}

- (UIColor *)getExtraLightGrayColor;
{
	return [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255 alpha:1.0];
}

- (void)applyLabelStyle:(UILabel *)label
{
	label.shadowColor = [self getExtraLightGrayColor];
	label.shadowOffset = CGSizeMake(0.5, 0.5);
	label.textColor = [self getExtraDarkGrayColor];
}

- (void)viewDidLayoutSubviews;
{
	if ( !once ) {
		once = YES;

		[self applyLabelStyle:self.title1];
		[self applyLabelStyle:self.title2];
		[self applyLabelStyle:self.scoreLabel];
		[self applyLabelStyle:self.scoreTitle];
		[self applyLabelStyle:self.timeLabel];
		[self applyLabelStyle:self.timeTitle];
		[self applyLabelStyle:self.withLove];
		
		[self refreshTimer:kGameDuration];
		[self refreshScore];
		//self.scoreLabel.text = @"0";
		
		UIImage *lifeimg = [UIImage imageNamed:kPathead];
		self.life1.image = lifeimg;
		self.life2.image = lifeimg;
		self.life3.image = lifeimg;
		
		timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
		
		UIImage *head = [UIImage imageNamed:kPathead];
		patheadContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, head.size.width/2.0, head.size.height/2.0)];
		patheadContainer.center = self.gameboard.center;
		patheadContainer.hidden = YES;
		patheadContainer.clipsToBounds = YES;
		[self.gameboard addSubview:patheadContainer];
		
		pathead = [[UIImageView alloc] initWithImage:head];
		pathead.frame = patheadContainer.bounds;
		pathead.contentMode = UIViewContentModeScaleAspectFit;
		[patheadContainer addSubview:pathead];
		
		tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(patheadTapped:)];
		[patheadContainer addGestureRecognizer:tap];
		
		miss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameboardTapped:)];
		[miss requireGestureRecognizerToFail:tap];
		[self.gameboard addGestureRecognizer:miss];
	
		gameRect = self.gameboard.frame;
		
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hit" ofType:@"m4a"];
		NSData *fileData = [NSData dataWithContentsOfFile:filePath];
		NSError *error = nil;
		beep = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
		[beep prepareToPlay];
		
		filePath = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"];
		fileData = [NSData dataWithContentsOfFile:filePath];
		error = nil;
		fail = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
		[fail prepareToPlay];
		
		running = NO;
	}
}

- (IBAction)startGame:(id)sender;
{
	lives = 3;
	speed = kSpeedMax;
	score = 0;
	self.startButton.hidden = YES;
	self.life1.hidden = NO;
	self.life2.hidden = NO;
	self.life3.hidden = NO;
	[self refreshLives];
	[self refreshScore];
	
	[self delayedAction:[self rand:5 toMax:20] / 10.0 closure:^{
		time = [NSDate timeIntervalSinceReferenceDate] + 60;
		patheadContainer.hidden = NO;
		[self movePathead];
		running = YES;
	}];
}

- (void)stopGame
{
	running = NO;
	patheadContainer.hidden = YES;
	self.startButton.hidden = NO;
}

- (void)patheadTapped:(UITapGestureRecognizer *)gest;
{
	speed = MAX(speed-kSpeedAdjust, kSpeedMin);
	score++;
	holdoff = kNewHeadHoldoff;
	pathead.image = [UIImage imageNamed:kPathead2];
	[beep stop];
	[beep play];
	[self refreshScore];
}

- (void)gameboardTapped:(UITapGestureRecognizer *)gest;
{
	if ( patheadContainer.hidden ) return;
	
	[fail play];
	
	lives--;
	
	if ( lives <= 0 ) {
		self.startButton.hidden = NO;
		patheadContainer.hidden = YES;
		self.life3.hidden = YES;
		self.life2.hidden = YES;
		self.life1.hidden = YES;
		[self stopGame];
		
	} else if ( lives == 2 ) {
		self.life3.hidden = YES;
		
	} else if ( lives == 1 ) {
		self.life3.hidden = YES;
		self.life2.hidden = YES;
	}
	
	[self refreshLives];
}

- (void)movePathead
{
	patheadContainer.hidden = NO;
	moveTime = speed;
	patheadContainer.center = [self getRandomPoint];
}

- (void)refreshScore
{
	self.scoreLabel.text = [NSString stringWithFormat:@"%zd", score];
}

- (void)refreshLives
{
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%zd", score];
}

- (void)refreshTimer:(NSInteger)secondsLeft
{
	self.timeLabel.text = [NSString stringWithFormat:@"%zd", secondsLeft];
}

- (IBAction)aboutAction:(id)sender;
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.brewmium.com?tag=pathead2015"]];
}

- (NSInteger)rand:(NSInteger)minimum toMax:(NSInteger)maximum
{
	NSInteger x = rand() % (maximum - minimum+1) + minimum;
	return x;
}

- (CGPoint)getRandomPoint
{
	return CGPointMake([self rand:0 toMax:gameRect.size.width], [self rand:0 toMax:gameRect.size.height]);
}

- (void)tick
{
	if ( running == NO ) return;

	if ( --moveTime <= 0 ) {
		[self movePathead];
	}
	
	if ( holdoff-- <= 0 ) {
		pathead.image = [UIImage imageNamed:kPathead];
	}
	
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	NSInteger timeLeft = time-now;
	if ( timeLeft <= 0 ) {
		[self stopGame];
		timeLeft = 0;
	}
	[self refreshTimer:timeLeft];
}

@end
