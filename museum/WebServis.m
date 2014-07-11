//
//  WebServis.m
//  Museum
//
//  Created by Ali BOZOĞ on 26.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "WebServis.h"

@implementation WebServis


-(NSDictionary *)servisAdi:(NSString *) servisAdi parametleriVeDegerleriAl:(NSDictionary *)parametler;
{
   NSString *url=@"http://alibozog.url.ph/";
    
    NSMutableDictionary* newParameters = [NSMutableDictionary dictionaryWithDictionary:parametler];
    
    NSURL* myURL = [self URLWithBaseURL:url
                              andService:servisAdi andParameters:newParameters];
    NSDictionary *sonuc=[self loadJSONDataFromURL:myURL];
    
    return sonuc;
}


-(NSDictionary *)loadJSONDataFromURL:(NSURL *)urlString;
{
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    NSError *error;
  //  NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}

- (NSURL*)URLWithBaseURL: (NSString*) baseURL andService:(NSString*) service andParameters: (NSDictionary*) parameters;
{
    NSString *url=[baseURL stringByAppendingString:service];
    url=[url stringByAppendingString:@"?"];
    NSArray *keys = [parameters allKeys];
    NSArray *value=[parameters allValues];
    
    NSString *sonuc=[[NSString alloc] init];
    for(int i=0;i<keys.count;i++)
    {
        sonuc=[url stringByAppendingString:@"&"];
        sonuc=[sonuc stringByAppendingString:[keys objectAtIndex:i]];
        sonuc=[sonuc stringByAppendingString:@"="];
        sonuc=[sonuc stringByAppendingString:[value objectAtIndex:i]];
        url=sonuc;
    }
    
    NSURL *sonucURL=[NSURL URLWithString:sonuc];
    return sonucURL;
}
@end





