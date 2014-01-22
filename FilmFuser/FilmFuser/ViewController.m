//
//  ViewController.m
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import "ViewController.h"

#ifndef MIN
#import <NSObjCRuntime.h>
#endif
#import "VideoScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()

@end

@implementation ViewController


@synthesize scrollView, addVideoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shouldRotate = YES;
        [self.view bringSubviewToFront: self.addVideoButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollViewContentSize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAdded: (UIImage*)image withMininumSize: (CGSize) minimumSize{
    
}

- (IBAction)addVideoButtonPressed:(id)sender {
    [self video];
}

- (IBAction)mergeVideoButtonPressed:(id)sender {
    [self merge];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
    
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [scrollView setScrollViewContentSize];
    
}

- (void)video {
    self.shouldRotate = NO;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSString* moviePath = nil;
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        moviePath = (NSString*)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        // NSLog(@"%@",moviePath);
        //NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        
    }
    
    NSURL* sourceMovieURL = [NSURL fileURLWithPath:moviePath];
    NSURL* outputPath = [sourceMovieURL URLByDeletingPathExtension];
    outputPath = [outputPath URLByDeletingLastPathComponent];
    NSMutableString* last_path_component =
            [[NSMutableString alloc] initWithString:[[sourceMovieURL URLByDeletingPathExtension] lastPathComponent]];
    [last_path_component appendString:@"~SQUARE"];
    outputPath = [outputPath URLByAppendingPathComponent:last_path_component];
    outputPath = [outputPath URLByAppendingPathExtension:@"MOV"];
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    [composition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // input clip
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // make it square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    // export
    
    
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
    exporter.videoComposition = videoComposition;
    exporter.outputURL=outputPath;
    exporter.outputFileType=AVFileTypeMPEG4;
    
    VideoButtonView* button = [self.scrollView buttonAdded];
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = false;
        switch ([exporter status]) {
            case AVAssetExportSessionStatusCompleted:
                success = true;
                NSLog(@"Export Completed");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"Export Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"Export Exporting");
                break;
            case AVAssetExportSessionStatusFailed:
            {
                NSError *error = [exporter error];
                NSLog(@"Export failed: %@", [error localizedDescription]);
                
                break;
            }
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                
                break;
            default:
                break;
        }
        
        if (success == true) {
            
            AVURLAsset* new_asset = [AVURLAsset URLAssetWithURL:outputPath options:nil];
            [button addVideoAsset:new_asset];
            
        }

    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[picker release];
}

- (void)merge {
    if([self.scrollView.buttonArray count] == 0) {
        __block UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"No films available to fuze!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [alert show];
            
        });
    }
    else {
        __block UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merging"
                                                    message:@"Films are currently fuzing!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [alert show];
            
        });
    }
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    
    videoComposition.frameDuration = CMTimeMake(1,30);
    
    videoComposition.renderScale = 1.0;
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    float time = 0;
    
    
    for (VideoButtonView* button in self.scrollView.buttonArray) {
        
        
        AVAsset *sourceAsset = button.videoAsset;
        
        NSError *error = nil;
        
        id videoTrack = [sourceAsset tracksWithMediaType:AVMediaTypeVideo];
        id audioTrack = [sourceAsset tracksWithMediaType:AVMediaTypeAudio];
        
        AVAssetTrack *sourceVideoTrack;
        AVAssetTrack *sourceAudioTrack;
        
        CMTime current_time = [composition duration];
        
        if(videoTrack) {
            
            sourceVideoTrack = [videoTrack objectAtIndex:0];
            [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:current_time error:&error];
        }
        if(audioTrack) {
            sourceAudioTrack = [audioTrack objectAtIndex:0];
            [compositionAudioTrack insertTimeRange:sourceAudioTrack.timeRange ofTrack:sourceAudioTrack atTime:current_time error:&error];
        }
        
        time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
        
    }
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    instruction.timeRange = compositionVideoTrack.timeRange;
    
    
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    
    NSString* myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video.mp4"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
        
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    
    
    exporter.outputURL=url;
    
    exporter.outputFileType = @"com.apple.quicktime-movie";
    
    //exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = false;
        switch ([exporter status]) {
            case AVAssetExportSessionStatusCompleted:
                success = true;
                NSLog(@"Export Completed");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"Export Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"Export Exporting");
                break;
            case AVAssetExportSessionStatusFailed:
            {
                NSError *error = [exporter error];
                NSLog(@"Export failed: %@", [error localizedDescription]);
                
                break;
            }
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                
                break;
            default:
                break;
        }
        if (success == true) {
            
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
                NSError *removeError = nil;
                [[NSFileManager defaultManager] removeItemAtURL:url error:&removeError];
            }];
            __block UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                            message:@"Films have been fuzed!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [alert show];
                
            });
        }
        
    }];
}

- (NSString*) applicationDocumentsDirectory
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
    
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    self.shouldRotate = YES;
}

- (BOOL)shouldAutorotate {
    return self.shouldRotate;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
