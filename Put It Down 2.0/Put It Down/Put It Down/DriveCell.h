//
//  DriveCell.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/8/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupsLabel;
@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;

@end

