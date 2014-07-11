//
//  WebServis.h
//  Museum
//
//  Created by Ali BOZOĞ on 26.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServis : NSObject
-(NSDictionary *)servisAdi:(NSString *) servisAdi parametleriVeDegerleriAl:(NSDictionary *)parametler;
-(NSDictionary *)loadJSONDataFromURL:(NSURL *)urlString;
- (NSURL*)URLWithBaseURL: (NSString*) baseURL andService:(NSString*) service andParameters: (NSDictionary*) parameters;
@end
