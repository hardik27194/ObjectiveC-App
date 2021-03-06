//
//  ViewController.m
//  FiveInARow
//
//  Created by brook on 1/24/14.
//  Copyright (c) 2014 brook. All rights reserved.
//

#import "ViewController.h"
#import "UIView_Chess.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize viewchess;
@synthesize btnReStart;
@synthesize btnExit;
@synthesize chessCtl;


#define iRow  15
#define iLineHigh 21
int iOwner;
bool bfinished;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
  
    iOwner = 0;
    bfinished = false;
    
    viewchess = [UIView_Chess alloc];
    [viewchess CreateChess:2 top:(rect.size.height-iRow*iLineHigh)/2 row:iRow column:iRow hight:iLineHigh width:iLineHigh];
    [self.view addSubview:viewchess];
    viewchess.tag = 100;
    
    chessCtl = [chessController alloc];
    [chessCtl Init:iRow column:iRow];
    
    //people vs robot
    [chessCtl enableAI:EASY];
}

- (void) assertWiner:(int)i y:(int)j
{
    switch ([chessCtl CountWar:i y:j]) {
        case BALCK:
        {
            bfinished = true;
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"Black Win。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
        }
        case WHITE:
        {
            bfinished = true;
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"White Win。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
}

- (void) addPoint:(UIView*)view
{
    NSString *strPoint = nil;
    if (iOwner & 0x1)
    {
        strPoint = @"white.png";

    }
    else
    {
        strPoint = @"black.png";
    }
    
    if ([viewchess addChess:view imgUrl:strPoint])
    {
        int i = [viewchess getRow:view];
        int j = [viewchess getColumn:view];
        
        if (iOwner & 0x1)
        {
            [chessCtl setMatrixValue:i y:j value:-1];
        }
        else
        {
            [chessCtl setMatrixValue:i y:j value:1];
        }
        ++iOwner;
        [self assertWiner:i y:j];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (bfinished) {
        return;
    }
    
    NSSet *allTouches = [event allTouches];    //return all objects relational
    UITouch *touch = [allTouches anyObject];   //return all objects in the view
    //CGPoint point = [touch locationInView:[touch view]]; //return the coordinate of the touch point
    
    if(touch.view.backgroundColor == [UIColor lightGrayColor] || touch.view.backgroundColor == [UIColor grayColor])
    {
       [self addPoint:touch.view];
    }
    
    //if enable the ai, after the people add chess, it's robot's turn.
    if (bfinished) {
        return;
    }
    if ([chessCtl isAIenabled])
    {
        int x,y;
        [chessCtl AIDropChess:&x y:&y value:-1];
        //get the view form known (x,y)
        [self addPoint:[viewchess getViewFormCoordinate:x y:y]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate
{
    return TRUE;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
   {
       for (UIView *View in [self.view subviews])
       {
           if (View.tag == 100)
           {
               int x = View.frame.origin.x;
               int y = View.frame.origin.y;
               int width = View.frame.size.width;
               int height = View.frame.size.height;
        
               View.frame = CGRectMake(y, x, width, height);
           }
       }
    }
}

- (IBAction)ReStartPressUp:(id)sender
{
    [viewchess clearChess];
    
    [chessCtl clearMatrix];
    
    bfinished = false;
    iOwner = 0;
}

- (IBAction)ExitPressUp:(id)sender
{
    exit(0);
}

@end
