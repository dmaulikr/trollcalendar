//
//  Tower.m
//  Troll Calendar
//
//  Created by Victor Engel on 1/18/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//
//copied from previous project until "default code"
//
//  Tower.m
//  TrollCalendar
//
//  Created by Victor Engel on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"
#import "TrollCalendarView.h"

@implementation Tower

@synthesize parentView;

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
   }
   return self;
}

+(NSInteger)getSerialForDate: (NSDate *)date
{
   //Return a serial day number from a date object.
   double serial;
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   formatter.dateFormat = @"dd MMM yyyy HH:mm ZZZ";
   NSDate *epoch = [formatter dateFromString:@"21 Mar 1975 05:57 +0000"];
   serial = floor((date.timeIntervalSince1970 - epoch.timeIntervalSince1970)/86400.0);
   return serial;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect

{
   NSDate *today;
   // Get date from TrollCalendarView.displayedDate.
   today = parentView.displayedDate;
   long towerNo, whichTower, whichPlatform;
   double totalWidth, incWidth, originX, originY, squareX1, squareX2, squareY1, squareY2;
   double serial = [Tower getSerialForDate:today];
   //now adjust leapdays
   if (serial<-10) {
      NSLog(@"Serial is %f",serial);
   }
   long fullCycles = floor(serial/12053);             //Number of 33 year cycles. This moves the stones from one platform to the next.
                                                      //A complete stone cycle is 7*33=231 years.
   /* There are 8 stones which move from one platform to the next. The time it takes all 8 stones to move one platform over is 12053 days.
      Every 1534 days one stone is moved. This occurs for 7 cycles. The eighth cycle lasts only 1315 days. So the times the stones are
      moved follows this chart:
    
    Stone #     Move #
    1           1534
    2           3068
    3           4602
    4           6136
    5           7670
    6           9204
    7          10738
    8          12053
    
    Each move number is +/- 12053N, where N is the full cycle number (fullCycles).
    */
   //NSInteger platformForStone;
   //for (int stoneNumber=1; stoneNumber<=8; stoneNumber++) {
   //   platformForStone = [self whichPlatform:serial forStoneNumber:stoneNumber];
   //   NSLog(@"Tower number for stone %d is %d for day %f",stoneNumber,platformForStone, serial);
   //}
   long leapDays = 8*fullCycles;
   long partCycle = serial - 12053 * fullCycles;
   leapDays += floor(partCycle/1534);
   serial -= leapDays;
   //   serial = 0;
   // M0 = move number (0 at epoch)
   // D  = disk number (1 is topmost disk)
   // N  = number of disks (9 for troll yard art)
   // S  = stack number (0, 1, 2)
   
   //M = (M0+INT((M0/(2^N-1))))  ;* My mod to make it work for a complete cycle.
   //   S = MOD((MOD((N + D + 1),2) + 1)*INT((M + 2^(D-1))/(2^D)),3)
   
   whichTower = (self.tag - 100)%3;
   whichPlatform = (self.tag - 100)/3;
   if (whichPlatform == 0) {
      //NSLog(@"%ld platform",whichPlatform);
   }
   //serial = 438;
   serial += (219*whichPlatform);
   double twon = pow(2,9);
   double term1 = twon-1;
   double term2 = serial / term1;
   serial = serial + floor(term2);
   // correct negative values later
   //if (serial < 0) serial += 219*7;
   while (serial<0) serial += 219*7;
   //   serial = (serial+floor((serial/(2^9-1))));
   //const int N=9;
   // Drawing code
   CGContextRef contextTowerView = UIGraphicsGetCurrentContext();
   CGContextSetLineWidth(contextTowerView, 1);
   [[UIColor brownColor] setStroke];
   
   CGRect boundingRectangle = self.bounds;
   // Check if this disk is on this tower
   //   NSInteger randomValue = arc4random()% 3;
   //if (randomValue == 1) {
   /* Do not always draw largest tile.
    CGContextAddRect(contextTowerView, boundingRectangle);
    CGContextStrokePath(contextTowerView);*/
   //}
   // Add additional 8 squares
   totalWidth = self.bounds.size.width;
   // float totalHeight = self.bounds.size.height;
   incWidth = totalWidth / 20;
   originX = boundingRectangle.origin.x;
   originY = boundingRectangle.origin.y;
   for (NSInteger index=0;index<=8;index++) {
      long term3 = 9 + index + 2;
      long term4 = term3%2 + 1;
      double term5 = pow(2,index);
      double term6 = serial + term5;
      double term7 = pow(2,(index+1));
      long term8 = floor(term6 / term7);
      long term9 = term4 * term8;
      long correctStack = term9%3;
      if (correctStack == whichTower ) {
         
         float indexValue = index;
         if (indexValue/2 - floor(indexValue/2) < 0.25) {
            [[UIColor blackColor] setStroke];
         } else {
            [[UIColor brownColor] setStroke];
         }
         towerNo = 9-index;
         squareX1 = originX + incWidth*towerNo +incWidth/100;
         squareX2 = originX + totalWidth - incWidth*towerNo-incWidth/100;
         squareY1 = originY + incWidth*towerNo +incWidth/100;
         squareY2 = originY + totalWidth - incWidth*towerNo-incWidth/100;
         CGRect tile = CGRectMake(squareX1, squareY1, (squareX2-squareX1), (squareY2-squareY1));
         CGContextAddRect(contextTowerView, tile);
         CGContextStrokePath(contextTowerView);
      }
   }
   // Update the date property.
}


@end

