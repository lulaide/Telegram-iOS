#import <MtProtoKit/MTCustomServerConfiguration.h>

#import <stdint.h>

@interface MTCustomServerConfigurationBundleMarker : NSObject
@end

@implementation MTCustomServerConfigurationBundleMarker
@end

static NSDictionary *MTCustomServerInfoDictionary(void) {
    NSBundle *bundle = [NSBundle bundleForClass:[MTCustomServerConfigurationBundleMarker class]];
    NSDictionary *infoDictionary = bundle.infoDictionary;
    if (infoDictionary[@"TGCustomServerURL"] != nil) {
        return infoDictionary;
    }

    NSDictionary *mainInfoDictionary = NSBundle.mainBundle.infoDictionary;
    return mainInfoDictionary != nil ? mainInfoDictionary : @{};
}

static NSURLComponents *MTCustomServerURLComponents(void) {
    id value = MTCustomServerInfoDictionary()[@"TGCustomServerURL"];
    if (![value isKindOfClass:[NSString class]] || [(NSString *)value length] == 0) {
        return nil;
    }

    NSURLComponents *components = [NSURLComponents componentsWithString:(NSString *)value];
    NSString *scheme = components.scheme.lowercaseString;
    if (!([scheme isEqualToString:@"tcp"] || [scheme isEqualToString:@"mtproto"])) {
        return nil;
    }
    if (components.host.length == 0 || components.port == nil) {
        return nil;
    }
    NSInteger port = components.port.integerValue;
    if (port <= 0 || port > UINT16_MAX) {
        return nil;
    }
    return components;
}

NSString *MTCustomServerHost(void) {
    return MTCustomServerURLComponents().host;
}

uint16_t MTCustomServerPort(void) {
    return (uint16_t)MTCustomServerURLComponents().port.unsignedIntegerValue;
}

int32_t MTCustomServerDatacenterId(void) {
    id value = MTCustomServerInfoDictionary()[@"TGCustomServerDatacenterId"];
    if (![value isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    NSInteger datacenterId = [(NSNumber *)value integerValue];
    if (datacenterId <= 0 || datacenterId > INT32_MAX) {
        return 0;
    }
    return (int32_t)datacenterId;
}

NSString *MTCustomServerPublicKey(void) {
    id value = MTCustomServerInfoDictionary()[@"TGCustomServerPublicKeyBase64"];
    if (![value isKindOfClass:[NSString class]] || [(NSString *)value length] == 0) {
        return nil;
    }

    NSData *data = [[NSData alloc] initWithBase64EncodedString:(NSString *)value options:0];
    if (data == nil) {
        return nil;
    }
    NSString *publicKey = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![publicKey containsString:@"-----BEGIN RSA PUBLIC KEY-----"] || ![publicKey containsString:@"-----END RSA PUBLIC KEY-----"]) {
        return nil;
    }
    return publicKey;
}

bool MTCustomServerIsEnabled(void) {
    return MTCustomServerHost() != nil
        && MTCustomServerPort() != 0
        && MTCustomServerDatacenterId() != 0
        && MTCustomServerPublicKey() != nil;
}
