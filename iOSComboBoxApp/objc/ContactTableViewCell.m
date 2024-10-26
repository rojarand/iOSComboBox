//
//  ContactTableViewCell.m
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 26/10/2024.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

// Set constants for padding and image size
static const CGFloat kPadding = 5.0;
static const CGFloat kImageSize = 30.0;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize and configure the contactImageView
        _contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, kPadding, kImageSize, kImageSize)];
        _contactImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contactImageView.layer.cornerRadius = kImageSize / 2;
        _contactImageView.clipsToBounds = YES;
        
        // Set a default system contact image (using SF Symbols)
        UIImage *defaultImage = [UIImage systemImageNamed:@"person.circle"];
        _contactImageView.image = defaultImage;
        
        [self.contentView addSubview:_contactImageView];
        
        // Initialize and configure the nameLabel
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding * 2 + kImageSize, kPadding, self.contentView.frame.size.width - kPadding * 3 - kImageSize, kImageSize)];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor labelColor];
        
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Update frames if needed to handle dynamic layouts
    _nameLabel.frame = CGRectMake(kPadding * 2 + kImageSize, kPadding, self.contentView.frame.size.width - kPadding * 3 - kImageSize, kImageSize);
}

// Method to configure the cell with a contact name and image
- (void)configureWithContactName:(NSString *)name {
    self.nameLabel.text = name;
}

+ (NSInteger)cellHeight {
    return kPadding * 2 + kImageSize;
}

@end

