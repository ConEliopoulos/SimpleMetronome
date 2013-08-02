//
//  ViewController.m
//  SimpleMetronome
//
//  Created by Con Eliopoulos on 31/07/13.
//  Copyright (c) 2013 Con Eliopoulos. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Attribution is not required, but appreciated :)
//

#import "ViewController.h"

@interface ViewController ()

/* Declare to private variables to track the state of the metronome */
@property BOOL isPlaying;
@property int beatNumber;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /* Preload our metronome sound so that it is ready to play. */
    [[AudioSamplePlayer sharedInstance] preloadAudioSample:@"tick"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startMetronome:(id)sender
{
    /* Check to see if we are already playing */
    if (!self.isPlaying) {
        /* The metronome is a loop that runs until it is cancelled.
           So that it does not interfere with the user interface, it
           should be run on a seperate queue.
         */
        dispatch_queue_t metronomeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(metronomeQueue, ^{
            /* Set the continuePlaying flag to YES.
               Reset beatNumber to 1.
               Run the metronome loop.
             */
            self.isPlaying = YES;
            self.beatNumber = 1;
            [self playMetronome];
        });
    }
}

- (IBAction)stopMetronome:(id)sender
{
    /* Set the continuePlaying flag to NO.
       Reset the beatNumberLabel text.
     */
    self.isPlaying = NO;
    self.beatNumberLabel.text = @"";
}

- (void) playMetronome
{
    /* We will continue looping until we are asked to stop */
    while (self.isPlaying)
    {
        /* The first beat is accented.
           Subsequent beats are played at a lower gain
           with a different pitch.
         */
        if (self.beatNumber == 1)
        {
            [[AudioSamplePlayer sharedInstance] playAudioSample:@"tick" gain:1.0f pitch:1.0f];
        }
        else
        {
            [[AudioSamplePlayer sharedInstance] playAudioSample:@"tick" gain:0.8f pitch:0.5f];
        }
        
        /* Updates to the user interface must be performed on the main thread */
        dispatch_sync (dispatch_get_main_queue(), ^{
            self.beatNumberLabel.text = [NSString stringWithFormat:@"%d", self.beatNumber];
        });
        
        /* Increment the beatNumber each time we loop.
           Note, this example has been built using a 4/4 
           time signature. After the 4th beat is played,
           beatNumber must return to the first beat.
         */
        self.beatNumber++;
        if (self.beatNumber > 4)
        {
            self.beatNumber = 1;
        }
        
        /* We need to monitor the time of the last beat so that we can determine
           when to play the next beat. We also need to check if the loop has
           been cancelled.
         */
        NSDate *curtainTime = [NSDate dateWithTimeIntervalSinceNow:0.5];
        NSDate *currentTime = [NSDate date];
        while (self.isPlaying && ([currentTime compare:curtainTime] != NSOrderedDescending))
        {
            [NSThread sleepForTimeInterval:0.01];
            currentTime = [NSDate date];
        }
    }
}

@end
