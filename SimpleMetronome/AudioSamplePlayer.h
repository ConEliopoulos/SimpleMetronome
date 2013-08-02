//
//  AudioSamplePlayer.h
//  MyOpenAL
//
//  Created by Con Eliopoulos on 29/07/13.
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

#import <Foundation/Foundation.h>

#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface AudioSamplePlayer : NSObject

/* Returns an instance to the shared singleton which governs access to 
   audio sample playback
 */
+ (AudioSamplePlayer *) sharedInstance;

/* Takes the name of a valid audio file and preloads the sample into
   a buffer.
   
   @param sampleName must be a valid file name without the extension. The
          sampleName will be used as the key for accessing the preloaded sample.
 */
- (void) preloadAudioSample:(NSString *)sampleName;

/* Takes the name of a valid audio sample and plays it
   using the default pitch and gain.
 
   @param sampleName must be a valid sample identifier that has
          been preloaded.
 */
- (void) playAudioSample:(NSString *)sampleName;

/* Takes the name of a valid audio sample identifier and plays it
   using at the specified gain and the default pitch.
 
   @param sampleName Must be a valid sample identifier that has
          been preloaded.
   @param gain The gain at which to play the sample (0.0 to 1.0)
 */
- (void) playAudioSample:(NSString *)sampleName gain:(float)gain;

/* Takes the name of a valid audio sample identifier and plays it
   using at the specified gain and pitch.
 
   @param sampleName Must be a valid sample identifier that has
          been preloaded.
   @param gain The gain at which to play the sample (0.0 to 1.0)
   @param pitch The pitch at which to play the sample (0.0 to 1.0)
 */
- (void) playAudioSample:(NSString *)sampleName gain:(float)gain pitch:(float)pitch;

/* Clean up and shut down openAL when we are finished with it.
   Deletes all buffers and sources.
 */
- (void) shutdownAudioSamplePlayer;

@end
