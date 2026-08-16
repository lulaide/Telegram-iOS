#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT bool MTCustomServerIsEnabled(void);
FOUNDATION_EXPORT NSString * _Nullable MTCustomServerHost(void);
FOUNDATION_EXPORT uint16_t MTCustomServerPort(void);
FOUNDATION_EXPORT int32_t MTCustomServerDatacenterId(void);
FOUNDATION_EXPORT NSString * _Nullable MTCustomServerPublicKey(void);

NS_ASSUME_NONNULL_END
