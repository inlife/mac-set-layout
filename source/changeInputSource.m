#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

int main (int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL b = NO;
    NSString *inputID;
    NSMutableString *thisID;
    TISInputSourceRef inputSource = NULL;

    if (argc < 2) b = YES; else inputID = [NSString stringWithUTF8String:argv[1]];

    CFArrayRef availableInputs = TISCreateInputSourceList(NULL, false);
    NSUInteger count = CFArrayGetCount(availableInputs);

    for (int i = 0; i < count; i++) {
        inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(availableInputs, i);
        CFStringRef type = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory);

        if (!CFStringCompare(type, kTISCategoryKeyboardInputSource, 0)) {
            thisID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);

            if (b) {
                printf("%s\n", [thisID UTF8String]);
            } else if ([thisID isEqualToString:inputID]) {
                b = YES;
                OSStatus err = TISSelectInputSource(inputSource);
                if (err) printf("Error %i\n", (int)err);
                break;
            }
        }
    }

    CFRelease(availableInputs);

    if (!b) printf("%s not available\n", thisID);
    [pool release];

    return 0;
}
