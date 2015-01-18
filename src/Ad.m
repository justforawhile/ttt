
#import <sys/time.h>

#import "Ad.h"

long long GetCurrentMillisSeconds ()
{
   //return (long long)(1000.0L * (double)CACurrentMediaTime ());
   
   struct timeval  tv;
   gettimeofday(&tv, NULL);

   return (long long) ((tv.tv_sec) * 1000 + (tv.tv_usec) / 1000); 
}

@implementation Ad {
   
}

- (id)init {
   self = [super init];
   
   if (self) {
      _invalidReason = nil;
      
      ready = NO;
      inPreparing = NO;
      lastPrepareTime = 0LL;
      numPrepareTimes = 0;

      posX = 0;
      posY = 0;
   }
 
   return self;
}

- (void)dealloc {
   [self dispose];

  // xcode: arc restrictions: arc forbids explicit message send of dealloc
  //[super dealloc];
}

- (id)initWithProperties:(NSString *)p type:(int)t unitID:(NSString *)unitid;
{
   _provider = p;
   _type = t;
   _unitID = unitid;
   
   return self;
}

- (void)destroy
{
   [self dispose];
   
   [self setInvalidReason:@"destroyed"];
}

- (void)dispose
{
}

- (void)pause
{
}

- (void)resume
{
}

- (int)getMaxNumPrepareTimes
{
   return 5;
}

- (int)getMinPrepareInternal
{
   return 15000;
}

- (BOOL)forbitRefreshingWhenReady
{
   return YES;
}

- (BOOL)isReady
{
   if (ready != [self isReadySafely]) {
      ready = ! ready;
      
      if (ready) {
         [self onPrepareReady];
      }
   }
   
   return ready;
}

- (BOOL)isReadySafely
{
   return ready;
}

- (void)resetReady
{
   ready = false;
}

- (void)onPrepareReady
{
   ready = YES;
   inPreparing = NO;
   numPrepareTimes = 0;
   lastPrepareTime = GetCurrentMillisSeconds ();
}

- (void)onPrepareFailed
{
   if (ready)
      return;
   
   if (numPrepareTimes >= [self getMaxNumPrepareTimes]) {
      [self setInvalidReason:@"failed to prepare"];
      return;
   }
   
   ++ numPrepareTimes;
   [self prepare]; // retry
}

- (void)prepare
{
   if ([self checkValidity] != nil)
      return;
   
   if (inPreparing && (GetCurrentMillisSeconds () - lastPrepareTime < [self getMinPrepareInternal]))
      return;
   
   if (ready && [self forbitRefreshingWhenReady])
      return;
   
   inPreparing = YES;
   
   [self reload];
   
   lastPrepareTime = GetCurrentMillisSeconds ();
}

- (void)reload
{
   
}

- (void)setPosition:(double)x posY:(double)y
{
   posX = x;
   posY = y;
   
   [self updatePosition];
}

- (void)updatePosition
{
}

- (void)getBounds:(double[])bounds
{
}

- (BOOL)isVisible
{
   return NO;
}

- (void)show
{
}

- (void)hide
{
}
 
@end
