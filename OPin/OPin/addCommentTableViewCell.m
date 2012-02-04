//
//  addCommentTableViewCell.m
//  mapProto
//
//  Created by John C Hudson and Bhaskar Ravi on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "addCommentTableViewCell.h"

@implementation addCommentTableViewCell

@synthesize editText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //self.backgroundColor = [UIColor clearColor];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
