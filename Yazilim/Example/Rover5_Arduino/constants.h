// Constants used in program

#define safedistance   120    // Safe distance between robot and objects
#define distancemax    160    // Maximum distance before an object is considered "out of range"
#define bestdistance   550    // Best distance to be from object so tracking won't be lost if object moves suddenly

#define pancenter      1400   // Center position of pan servo in uS
#define panmin         700    // Pan servo lower limit in uS
#define panmax         2100   // Pan servo upper limit in uS
#define panscalefact   6      // Scale factor to prevent pan servo overcorrecting

#define tiltcenter     1500   // Center position of tilt servo in uS
#define tiltmin        700    // Tilt servo lower limit in uS
#define tiltmax        1750   // Tilt servo upper limit in uS
#define tiltscalefact  7      // Scale factor to prevent tilt servo overcorrecting


// deadband values prevent the robot over reacting to small movements of the object

#define disdeadband    50     // Distance deadband allows the object to change distance a small amount without robot reacting
#define pandeadband    20     // Pan deadband allows head to pan a small amount before body begins tracking object in uS                              
