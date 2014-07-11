//
//  listBeaconTableViewCell.h
//  Museum
//
//  Created by Ali BOZOĞ on 21.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listBeaconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *eserLbl;
@property NSString *eserID;
@property (nonatomic, strong) NSURLSessionDataTask *imageDownloadTask;
@property (strong, nonatomic) IBOutlet UIImageView *takipResim;

@end
