//
//  DDMenu.h
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-14.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMenu : UIView{
    int menuSize;

}
-(void)DropDownMenu;
-(void)HideDownMenu;

@property (strong, nonatomic) IBOutlet UIButton *omOssButton;
@property (strong, nonatomic) IBOutlet UIButton *listViewButton;
@property (strong, nonatomic) IBOutlet UIButton *productViewButton;

@end
