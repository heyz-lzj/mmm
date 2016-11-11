//
//  UIImageView+WebImage.m
//  miniu
//
//  Created by Apple on 15/11/6.
//  Copyright © 2015年 SimMan. All rights reserved.
//


#import "UIImageView+WebImage.h"


NSOperationQueue *queue = nil;



@implementation UIImageView (WebImage)

/*
 - (void)setImageWithURL:(NSURL *)url {
 
 NSData *data = [NSData dataWithContentsOfURL:url];
 
 UIImage *img = [UIImage imageWithData:data];
 
 self.image = img;
 
 }
 */

- (void)setImageWithURL:(NSURL *)url {
    
    if (queue == nil) {
        //1.创建一个线程队列
        queue = [[NSOperationQueue alloc] init];
        
        queue.maxConcurrentOperationCount = 1;
        
    }
    
    //异步、同步
    [queue addOperationWithBlock:^{
        
        @autoreleasepool {
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            //压缩图片
            CGSize newSize;
            CGImageRef imageRef = nil;
            
            if ((image.size.width / image.size.height) < (kScreen_Width / kScreen_Width)) {
                newSize.width = image.size.width;
                newSize.height = image.size.width * kScreen_Width / kScreen_Width;
                
                imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
                
            } else {
                newSize.height = image.size.height;
                newSize.width = image.size.height * kScreen_Width / kScreen_Width;
                
                imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
                
            }
            //跳到主线程上去执行如下代码
            //            self.image = img;
            
            //            [self goMain];
            
            //让主线程去执行此方法：goMain
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            [self performSelectorOnMainThread:@selector(goMain:) withObject:img waitUntilDone:NO];
            
        }
        
    }];
}


- (void)goMain:(UIImage *)img {
    
    self.image = img;
    
}

@end
