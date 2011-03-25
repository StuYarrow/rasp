//
//  RaspController.m
//  rasp
//
//  Created by Jelle Vandebeeck on 13/03/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "RaspController.h"

#import "ASIHTTPRequest.h"
#import "JSON.h"

static RaspController *singletonRaspController = nil;

@interface RaspController () {
	NSMutableArray *_charts;
    NSMutableDictionary *_countries;
}
@end

@interface RaspController (Loading)
- (void)loadChartsForCountry:(NSString *)country;
- (void)loadCountries;
@end

@implementation RaspController

@synthesize delegate=_delegate;

#pragma mark -
#pragma mark Singleton

+ (RaspController *)instance {
	@synchronized(self) {
		if (!singletonRaspController) {
			singletonRaspController = [[RaspController alloc] init];
            [singletonRaspController loadCountries];
		}
	}
	return singletonRaspController;
}

#pragma mark -
#pragma mark Getters

- (NSDictionary *)countries {
    return _countries;
}

#pragma - Countries

- (void)loadCountries {
	_countries = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]] retain];
}

#pragma mark - Charts

- (void)loadChartsForCountry:(NSString *)country {
	NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"menu?language=%@&country=%@",current_language, country]];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self.delegate];
    [request setTimeOutSeconds:25];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setUseKeychainPersistence:YES];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    [_countries release], _countries = nil;
    [super dealloc];
}

@end
