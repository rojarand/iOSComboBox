//
//  ContactTableViewCell.h
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 26/10/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *contactImageView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)configureWithContactName:(NSString *)name;
+ (NSInteger)cellHeight;

@end


NS_ASSUME_NONNULL_END
