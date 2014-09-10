LeapObjectiveC-32-64-ARC-MRC (for Leap SDK 2.1.2)
=================================================

The LeapObjectiveC files and Cocoa original Leap Motion Sample Project modified to handle both ARC and MRC, in 32 and 64 bits modes.

People who want to make apps linking to 32 bits only libraries, can't use the original LeapObjectiveC files without modifications, because they're using Automatic Reference Counting. 

This project bundles the modified LeapObjectiveC files: 

- added 2 versions of each allocation / deallocation and a compiler command to check if the user is building with ARC or without ARC.
- added instance variables declarations, if the compiler is not using ARC.
- passed LeapVector float values to double, in order to handle vectors operations on "little" coordinates system (eg -1 -> 1.)

How
===

- Open the Sample XCode project.
- It is linking to leapLib.dylib situated in the /leap folder: link to the specific location on your computer.
