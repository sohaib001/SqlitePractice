//
//  DatabaseViewController.m
//  SqlitePractice
//
//  Created by Sohaib Muhammad on 15/03/2013.
//  Copyright (c) 2013 coeus. All rights reserved.
//

#import "DatabaseViewController.h"

@interface DatabaseViewController ()

@end

@implementation DatabaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *docsDir;
    NSArray *dirPaths;
    // get doucment dirctory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"Total directories paths %d",dirPaths.count);
    
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
   
    // for file manipulation
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if (![filemgr fileExistsAtPath:databasePath]) {
    
        // convert the database path in to UTF8String encoding
        const char *dbPath = [databasePath UTF8String];
        
        
        //1st-step: open the database
        
        if (sqlite3_open(dbPath,&db)==SQLITE_OK) {
            
            NSLog(@"Database successfull opened");
            
             //2nd-step: prepare the statement
            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            // 
            const char *query_stmt = [sql_stmt UTF8String];
            
            sqlite3_stmt *statement;
        
            if(sqlite3_prepare_v2(db,query_stmt,-1,&statement,NULL)== SQLITE_OK){
                NSLog(@"SQL statement created successfully");
            }
            else{
                NSLog(@"SQL not created successfully");
            }
            
            //3rd-step: execute the prepared statement. it will return the value depending upon the nature of the sql query
            sqlite3_step(statement);
            

            //4th-step: it will delete the prepared statement from the memory
            sqlite3_finalize(statement);
 
            //5th-step: it will close the database
            sqlite3_close(db);
            
            
            
           // below fuction provide the combined functionality of sqlite3_prepare_v2(), sqlite3_step() and sqlite3_finalize() into a single function call
//            char *errMsg;
//            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
//            {
//                self.lblStatus.text = @"Failed to create table";
//            }
 
        
        }
        else{
            self.lblStatus.text =@"Database failed to open";

        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSavePressed:(UIButton *)sender {
    
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", self.name.text, self.Address.text, self.phoneNo.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            self.lblStatus.text = @"Contact added";
            self.name.text = @"";
            self.Address.text = @"";
            self.phoneNo.text = @"";
        } else {
            self.lblStatus.text = @"Failed to add contact";
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
}

- (IBAction)btnFindPressed:(UIButton *)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT address, phone FROM contacts WHERE name=\"%@\"", self.name.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                self.Address.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                self.phoneNo.text = phoneField;
                
                self.lblStatus.text = @"Match found";
                
            } else {
                self.lblStatus.text = @"Match not found";
                self.Address.text = @"";
                self.phoneNo.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(db);
    }
}
@end
