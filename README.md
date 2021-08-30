# ApexAHK-Reduce-recoil
I'm making AHK script with auto detect weapon function. This script work fine but have some issue.
I think I would share this script so that everyone can help to improve this script.
I implement from [Updated [Apex Legends NoRecoil Script] - PART 2](https://www.unknowncheats.me/forum/apex-legends/328576-updated-apex-legends-norecoil-script-2-a.html)  and some GitHub ( GitHub link removed because it break the UC rule )
Anyone please leave a problem that u found so I can fix that problem. But I know the recoil pattern is so wried. I will make it better but now I focused on making the auto detect weapon function work perfectly. 

Script now support [Tientie (Vengefulcrop)](https://www.unknowncheats.me/forum/apex-legends/467406-method-generating-recoil-patterns-ahk-script-development-testing.html) reciol patterns generating method. ( You can see pattern example in file PatternExample.txt )

## Know issue
* This script is for 1920 x 1080 resolution only. ( Will support other resolution in future )
* Random mouse freeze ( Rarely happen )
* Recoil pattern so weird because I copy paste from many source. (ฺ Will fix that in future )
* Auto weapons detection is not accurate. ( Still working on it )
* Updated pattern still not perfect.
* To make auto fire work you must bind your secondary shoot key to 9.
* To disable auto fire delete the weapon pattern
Code:
`<(Weapon name)_Pattern := { Delete all of this }>`