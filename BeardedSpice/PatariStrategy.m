//
//  PatariStrategy.m
//  BeardedSpice
//
//  Created by Kamil Waheed on 19/02/2015.
//  Copyright (c) 2015 Tyler Rhodes / Jose Falcon. All rights reserved.
//

#import "PatariStrategy.h"

@implementation PatariStrategy

-(id) init
{
    self = [super init];
    if (self) {
        predicate = [NSPredicate predicateWithFormat:@"SELF LIKE[c] '*beta.patari.pk*'"];
    }
    return self;
}

-(BOOL) accepts:(id <Tab>)tab
{
    return [predicate evaluateWithObject:[tab URL]];
}

-(NSString *) toggle
{
    return @"(function(){angular.element('[ng-controller=\"PlayerstateCtrl\"]').scope().playPause()})()";
}

-(NSString *) previous
{
    return @"(function(){angular.element('[ng-controller=\"PlayerstateCtrl\"]').scope().previousSong()})()";
}

-(NSString *) next
{
    return @"(function(){angular.element('[ng-controller=\"PlayerstateCtrl\"]').scope().nextSong()})()";
}

-(NSString *) pause
{
    return @"(function(){angular.element('[ng-controller=\"PlayerstateCtrl\"]').scope().playerState.currentSongInstance.pause()})()";
}

-(NSString *) displayName
{
    return @"Patari.pk";
}

@end
