//
//  DatabaseViewController.h
//  SqlitePractice
//
//  Created by Sohaib Muhammad on 15/03/2013.
//  Copyright (c) 2013 coeus. All rights reserved.

// Description :

// This is the simple example of the sqlite database. 
// http://www.techotopia.com/index.php/IOS_4_iPhone_Database_Implementation_using_SQLite

#import <UIKit/UIKit.h>

#import <sqlite3.h>


@interface DatabaseViewController : UIViewController{
    @private
    sqlite3 *db;
    NSString *databasePath;
    
}
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnFind;
- (IBAction)btnSavePressed:(UIButton *)sender;
- (IBAction)btnFindPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *Address;
@property (strong, nonatomic) IBOutlet UITextField *phoneNo;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
