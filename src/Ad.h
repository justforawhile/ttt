#ifndef _AD_H
#define _AD_H

#import <Foundation/Foundation.h>

@interface Ad : NSObject {
   BOOL ready;
   BOOL inPreparing;
   long long lastPrepareTime;
   int numPrepareTimes;

   double posX;
   double posY;
}

@property(nonatomic, assign, readonly) NSString *provider;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) NSString *unitID;

@property(nonatomic, assign, getter=checkValidity) NSString *invalidReason;

- (id)initWithProperties:(NSString *)provider type:(int)t unitID:(NSString *)unitid;

- (void)destroy; // DON'T override this method

- (void)dispose; // to overrode
- (void)pause; // to overrode
- (void)resume; // to overrode

- (int)getMaxNumPrepareTimes; // to overrode or not
- (int)getMinPrepareInternal; // to overrode or not
- (BOOL)forbitRefreshingWhenReady; // to overrode or not

- (BOOL)isReady; // DON'T override this method
- (BOOL)isReadySafely; // to overrode or not
- (void)resetReady; // DON'T override this method
- (void)onPrepareReady; // DON'T override this method
- (void)onPrepareFailed; // DON'T override this method
- (void)prepare; // DON'T override this method
- (void)reload; // to overrode

- (void)setPosition:(double)x posY:(double)y; // DON'T override this method
- (void)updatePosition; // to overrode
- (void)getBounds:(double[])bounds; // to overrode
- (BOOL)isVisible; // to overrode
- (void)show; // to overrode
- (void)hide; // to overrode

@end

#endif
