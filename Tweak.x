#import <Foundation/Foundation.h>
#include <stdlib.h>

BOOL powerBtnPressed=NO;
int volumeupcount=0;
int volumedowncount=0;

struct __IOHIDEvent;

int32_t IOHIDEventGetType(struct __IOHIDEvent *event);
int IOHIDEventGetIntegerValue(struct __IOHIDEvent *event,long long value);

%hook BKButtonHIDEventProcessor

- (id)processEvent:(struct __IOHIDEvent **)event sender:(id)sender dispatcher:(id)dispatcher {
	if(IOHIDEventGetType(*event)==3){ //3: Keyboard event
		int usagePage=IOHIDEventGetIntegerValue(*event,196608LL);
		int usage=IOHIDEventGetIntegerValue(*event,196609LL);
		BOOL down=IOHIDEventGetIntegerValue(*event,196610LL)!=0;
		if(usagePage==12){
			if(usage==0x30){
				powerBtnPressed=down;
				if(!down){
					volumeupcount=volumedowncount=0;
				}
			}else if(usage==0xe9){
				if(down&&powerBtnPressed){
					volumeupcount++;
					if(volumedowncount==volumeupcount){
						if(volumedowncount==1){
							system("sbreload");
						}else if(volumedowncount==2){
							system("ldrestart");
						}else if(volumedowncount==3){
							exit(1);
						}
					}
					if(volumedowncount!=0){
						return nil;
					}
				}
			}else if(usage==0xea){
				if(down&&powerBtnPressed){
					volumedowncount++;
					if(volumeupcount!=0){
						volumeupcount=0;
					}
					return nil;
				}
			}
		}
	}
	return %orig;
}

%end