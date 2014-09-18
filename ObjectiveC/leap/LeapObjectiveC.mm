/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import "LeapObjectiveC.h"

//////////////////////////////////////////////////////////////////////////
// MainThread category for posting notifications to the main application thread
@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;

@end


//////////////////////////////////////////////////////////////////////////
//VECTOR
@implementation LeapVector

// Xcode 4.3 and earlier do not auto-synthesize scalar properties
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

- (id)initWithX:(double)x y:(double)y z:(double)z
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

- (id)initWithVector:(const LeapVector *)vector
{
    self = [super init];
    if (self) {
        _x = [vector x];
        _y = [vector y];
        _z = [vector z];
    }
    return self;
}

- (id)initWithLeapVector:(void *)leapVector
{
    self = [super init];
    if (self) {
        const Leap::Vector *v = (Leap::Vector *)leapVector;
        _x = v->x;
        _y = v->y;
        _z = v->z;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f, %f)", _x, _y, _z];
}

- (double)magnitude
{
    return sqrt(_x * _x + _y * _y + _z * _z);
}

- (double)magnitudeSquared
{
    return _x * _x + _y * _y + _z * _z;
}

- (double)distanceTo:(const LeapVector *)vector
{
    return sqrt((_x - [vector x]) * (_x - [vector x]) +
                (_y - [vector y]) * (_y - [vector y]) +
                (_z - [vector z]) * (_z - [vector z]));
}

- (double)angleTo:(const LeapVector *)vector
{
    double denom = [self magnitudeSquared] * [vector magnitudeSquared];
    if (denom <= 0.0f) {
        return 0.0f;
    }
    return acos([self dot:vector] / sqrt(denom));
}

- (double)pitch
{
    return atan2(_y, -_z);
}

- (double)roll
{
    return atan2(_x, -_y);
}

- (double)yaw
{
    return atan2(_x, -_z);
}

- (LeapVector *)plus:(const LeapVector *)vector
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:(_x + [vector x]) y:(_y + [vector y]) z:(_z + [vector z])] autorelease];
#else
    return [[LeapVector alloc] initWithX:(_x + [vector x]) y:(_y + [vector y]) z:(_z + [vector z])];
#endif
}

- (LeapVector *)minus:(const LeapVector *)vector
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:(_x - [vector x]) y:(_y - [vector y]) z:(_z - [vector z])] autorelease];
#else
    return [[LeapVector alloc] initWithX:(_x - [vector x]) y:(_y - [vector y]) z:(_z - [vector z])];
#endif
}

- (LeapVector *)negate
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:(-_x) y:(-_y) z:(-_z)] autorelease];
#else
    return [[LeapVector alloc] initWithX:(-_x) y:(-_y) z:(-_z)];
#endif
}

- (LeapVector *)times:(double)scalar
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:(scalar*_x) y:(scalar*_y) z:(scalar*_z)] autorelease];
#else
    return [[LeapVector alloc] initWithX:(scalar*_x) y:(scalar*_y) z:(scalar*_z)];
#endif
}

- (LeapVector *)divide:(double)scalar
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:(_x/scalar) y:(_y/scalar) z:(_z/scalar)] autorelease];
#else
    return [[LeapVector alloc] initWithX:(_x/scalar) y:(_y/scalar) z:(_z/scalar)];
#endif
}

- (BOOL)equals:(const LeapVector *)vector
{
    return _x == [vector x] && _y == [vector y] && _z == [vector z];
}

- (double)dot:(const LeapVector *)vector
{
    return _x * [vector x] + _y * [vector y] + _z * [vector z];
}

- (LeapVector *)cross:(const LeapVector *)vector
{
    const Leap::Vector me(_x, _y, _z);
    const Leap::Vector other([vector x], [vector y], [vector z]);
    const Leap::Vector product = me.cross(other);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:product.x y:product.y z:product.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:product.x y:product.y z:product.z];
#endif
}

- (LeapVector *)normalized
{
    const Leap::Vector me(_x, _y, _z);
    const Leap::Vector norm = me.normalized();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:norm.x y:norm.y z:norm.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:norm.x y:norm.y z:norm.z];
#endif
}

- (NSArray *)toNSArray
{
    return [NSArray arrayWithObjects:[NSNumber numberWithDouble:_x], [NSNumber numberWithDouble:_y], [NSNumber numberWithDouble:_z], nil];
}

- (NSMutableData *)toFloatPointer
{
#if !__has_feature(objc_arc)
    NSMutableData *data = [[[NSMutableData alloc] initWithCapacity:4 * sizeof(float)] autorelease];
#else
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:4 * sizeof(float)];
#endif
    float *rawData = (float *)[data mutableBytes];
    rawData[0] = _x;
    rawData[1] = _y;
    rawData[2] = _z;
    rawData[3] = 0; // encourage alignment
    return data;
}

+ (LeapVector *)zero
{
    const Leap::Vector& v = Leap::Vector::zero();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)xAxis
{
    const Leap::Vector& v = Leap::Vector::xAxis();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)yAxis
{
    const Leap::Vector& v = Leap::Vector::yAxis();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)zAxis
{
    const Leap::Vector& v = Leap::Vector::zAxis();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)left
{
    const Leap::Vector& v = Leap::Vector::left();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)right
{
    const Leap::Vector& v = Leap::Vector::right();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)down
{
    const Leap::Vector& v = Leap::Vector::down();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)up
{
    const Leap::Vector& v = Leap::Vector::up();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)forward
{
    const Leap::Vector& v = Leap::Vector::forward();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

+ (LeapVector *)backward
{
    const Leap::Vector& v = Leap::Vector::backward();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:v.x y:v.y z:v.z] autorelease];
#else
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
#endif
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

@end;

//////////////////////////////////////////////////////////////////////////
//MATRIX
@implementation LeapMatrix

// Xcode 4.2 does not auto-synthesize properties
@synthesize xBasis = _xBasis;
@synthesize yBasis = _yBasis;
@synthesize zBasis = _zBasis;
@synthesize origin = _origin;

- (id)initWithXBasis:(const LeapVector *)xBasis yBasis:(const LeapVector *)yBasis zBasis:(const LeapVector *)zBasis origin:(const LeapVector *)origin
{
    self = [super init];
    if (self) {
        _xBasis = [[LeapVector alloc] initWithVector:xBasis];
        _yBasis = [[LeapVector alloc] initWithVector:yBasis];
        _zBasis = [[LeapVector alloc] initWithVector:zBasis];
        _origin = [[LeapVector alloc] initWithVector:origin];
    }
    return self;
}

- (id)initWithMatrix:(LeapMatrix *)matrix
{
    self = [super init];
    if (self) {
        _xBasis = [[LeapVector alloc] initWithVector:[matrix xBasis]];
        _yBasis = [[LeapVector alloc] initWithVector:[matrix yBasis]];
        _zBasis = [[LeapVector alloc] initWithVector:[matrix zBasis]];
        _origin = [[LeapVector alloc] initWithVector:[matrix origin]];
    }
    return self;
}

- (id)initWithLeapMatrix:(void *)matrix
{
    self = [super init];
    if (self) {
        Leap::Matrix *m = (Leap::Matrix *)matrix;
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m->xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m->yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m->zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m->origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians
{
    self = [super init];
    if (self) {
        Leap::Vector v([axis x], [axis y], [axis z]);
        Leap::Matrix m(v, angleRadians);
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians translation:(const LeapVector *)translation
{
    self = [super init];
    if (self) {
        Leap::Vector leapAxis([axis x], [axis y], [axis z]);
        Leap::Vector leapTranslation([translation x], [translation y], [translation z]);
        Leap::Matrix m(leapAxis, angleRadians, leapTranslation);
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"xBasis:%@ yBasis:%@ zBasis:%@ origin:%@", _xBasis, _yBasis, _zBasis, _origin];
}

- (LeapVector *)transformPoint:(const LeapVector *)point
{
    const LeapVector *a = [_xBasis times:[point x]];
    const LeapVector *b = [_yBasis times:[point y]];
    const LeapVector *c = [_zBasis times:[point z]];
    return [[[a plus:b] plus:c] plus:_origin];
}

- (LeapVector *)transformDirection:(const LeapVector *)direction
{
    const LeapVector *a = [_xBasis times:[direction x]];
    const LeapVector *b = [_yBasis times:[direction y]];
    const LeapVector *c = [_zBasis times:[direction z]];
    return [[a plus:b] plus:c];
}

- (LeapMatrix *)rigidInverse
{
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix temp(localXBasis, localYBasis, localZBasis, localOrigin);

    Leap::Matrix inverted = temp.rigidInverse();
#if !__has_feature(objc_arc)
    LeapMatrix *rigidInverse = [[[LeapMatrix alloc] initWithXBasis:[[LeapVector alloc] initWithLeapVector:&inverted.xBasis]
                                                            yBasis:[[LeapVector alloc] initWithLeapVector:&inverted.yBasis]
                                                            zBasis:[[LeapVector alloc] initWithLeapVector:&inverted.zBasis]
                                                            origin:[[LeapVector alloc] initWithLeapVector:&inverted.origin]] autorelease];
#else
    LeapMatrix *rigidInverse = [[LeapMatrix alloc] initWithXBasis:[[LeapVector alloc] initWithLeapVector:&inverted.xBasis]
                                                           yBasis:[[LeapVector alloc] initWithLeapVector:&inverted.yBasis]
                                                           zBasis:[[LeapVector alloc] initWithLeapVector:&inverted.zBasis]
                                                           origin:[[LeapVector alloc] initWithLeapVector:&inverted.origin]];
#endif
    return rigidInverse;
}

- (LeapMatrix *)times:(const LeapMatrix *)other
{
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithXBasis:[self transformDirection:[other xBasis]] yBasis:[self transformDirection:[other yBasis]] zBasis:[self transformDirection:[other zBasis]] origin:[self transformPoint:[other origin]]] autorelease];
#else
    return [[LeapMatrix alloc] initWithXBasis:[self transformDirection:[other xBasis]] yBasis:[self transformDirection:[other yBasis]] zBasis:[self transformDirection:[other zBasis]] origin:[self transformPoint:[other origin]]];
#endif
}

- (BOOL)equals:(const LeapMatrix *)other
{
    return [_xBasis equals:[other xBasis]] && [_yBasis equals:[other yBasis]] && [_zBasis equals:[other zBasis]];
}

- (NSMutableArray *)toNSArray3x3
{
    double double_ar[9];
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    m.toArray3x3<double>(double_ar);
    NSMutableArray *ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < 9; i++) {
        [ar addObject:[NSNumber numberWithDouble:double_ar[i]]];
    }
    return ar;
}

- (NSMutableArray *)toNSArray4x4
{
    double double_ar[16];
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    m.toArray4x4<double>(double_ar);
    NSMutableArray *ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < 16; i++) {
        [ar addObject:[NSNumber numberWithDouble:double_ar[i]]];
    }
    return ar;
}

- (NSMutableData *)toFloatPointer3x3
{
    NSMutableArray *ar = [self toNSArray3x3];
#if !__has_feature(objc_arc)
    NSMutableData *data = [[[NSMutableData alloc] initWithCapacity:12 * sizeof(float)] autorelease];
#else
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:12 * sizeof(float)];
#endif
    float *rawData = (float *)data.mutableBytes;
    for (NSUInteger i = 0; i < 12; i++) {
        if (i < 9) {
            rawData[i] = [[ar objectAtIndex:i] floatValue];
        }
        else {
            rawData[i] = 0; // for alignment
        }
    }
    return data;
}

- (NSMutableData *)toFloatPointer4x4
{
    NSMutableArray *ar = [self toNSArray4x4];
#if !__has_feature(objc_arc)
    NSMutableData *data = [[[NSMutableData alloc] initWithCapacity:16 * sizeof(float)] autorelease];
#else
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:16 * sizeof(float)];
#endif
    float *rawData = (float *)data.mutableBytes;
    for (NSUInteger i = 0; i < 16; i++) {
        rawData[i] = [[ar objectAtIndex:i] floatValue];
    }
    return data;
}

+ (LeapMatrix *)identity
{
    const Leap::Matrix& m = Leap::Matrix::identity();
    return [[LeapMatrix alloc] initWithLeapMatrix:(void *)&m];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_xBasis release];
    [_yBasis release];
    [_zBasis release];
    [_origin release];
    [super dealloc];
}
#endif

@end

//////////////////////////////////////////////////////////////////////////
//POINTABLE
@implementation LeapPointable
#if __has_feature(objc_arc)
{
    Leap::Pointable *_interfacePointable;
}
#endif

@synthesize frame = _frame;
@synthesize hand = _hand;

- (id)initWithPointable:(void *)pointable frame:(LeapFrame *)frame hand:(LeapHand *)hand
{
    self = [super init];
    if (self) {
        const Leap::Pointable *castedPointable = (const Leap::Pointable *)pointable;
        if (castedPointable->isFinger()) {
            _interfacePointable = new Leap::Finger(*(const Leap::Finger *)castedPointable);
        }
        else if (castedPointable->isTool()) {
            _interfacePointable = new Leap::Tool(*(const Leap::Tool *)castedPointable);
        }
        else {
            _interfacePointable = new Leap::Pointable(*castedPointable);
        }
        _frame = frame;
        _hand = hand;
    }
    return self;
}

+ (LeapPointable *)typedPointableAlloc:(void *)leapPointable
{
    LeapPointable *pointable;
    const Leap::Pointable *castedPointable = (const Leap::Pointable *)leapPointable;
    if (castedPointable->isFinger()) {
        pointable = [LeapFinger alloc];
    } else if (castedPointable->isTool()) {
        pointable = [LeapTool alloc];
    }
    else {
        pointable = [LeapPointable alloc];
    }
    return pointable;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Pointable";
    }
    return [NSString stringWithFormat:@"Pointable Id:%d", [self id]];
}

- (void *)interfacePointable
{
    return _interfacePointable;
}

- (int32_t)id
{
    return _interfacePointable->id();
}

- (LeapVector *)tipPosition
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfacePointable->tipPosition().x y:_interfacePointable->tipPosition().y z:_interfacePointable->tipPosition().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfacePointable->tipPosition().x y:_interfacePointable->tipPosition().y z:_interfacePointable->tipPosition().z];
#endif
}

- (LeapVector *)tipVelocity
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfacePointable->tipVelocity().x y:_interfacePointable->tipVelocity().y z:_interfacePointable->tipVelocity().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfacePointable->tipVelocity().x y:_interfacePointable->tipVelocity().y z:_interfacePointable->tipVelocity().z];
#endif
}

- (LeapVector *)direction
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfacePointable->direction().x y:_interfacePointable->direction().y z:_interfacePointable->direction().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfacePointable->direction().x y:_interfacePointable->direction().y z:_interfacePointable->direction().z];
#endif
}

- (float)width
{
    return _interfacePointable->width();
}

- (float)length
{
    return _interfacePointable->length();
}

- (BOOL)isFinger
{
    return _interfacePointable->isFinger();
}

- (BOOL)isTool
{
    return _interfacePointable->isTool();
}

- (BOOL)isExtended
{
    return _interfacePointable->isExtended();
}

- (BOOL)isValid
{
    return _interfacePointable->isValid();
}

- (LeapPointableZone)touchZone
{
    return (LeapPointableZone)_interfacePointable->touchZone();
}

- (float)touchDistance
{
    return _interfacePointable->touchDistance();
}

- (LeapVector *)stabilizedTipPosition
{
    const Leap::Vector leapVector = _interfacePointable->stabilizedTipPosition();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)timeVisible
{
    return _interfacePointable->timeVisible();
}

- (LeapFrame *)frame
{
    NSAssert(_frame != nil, @"Pointable's frame property has been deallocated due to weak ARC reference. Retain a strong pointer to this frame if you wish to access it later.");
    return _frame;
}

- (LeapHand *)hand
{
    NSAssert(_hand != nil, @"Pointable's hand property has been deallocated due to weak ARC reference. Retain a strong pointer to this hand (or parent LeapGesture object, when applicable) if you wish to access it later.");
    return _hand;
}

- (void)dealloc
{
    delete _interfacePointable;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (LeapPointable *)invalid
{
    static const Leap::Pointable &invalid_pointable = Leap::Pointable::invalid();
#if !__has_feature(objc_arc)
    LeapPointable *pointable = [[[LeapFinger alloc] initWithPointable:(void *)&invalid_pointable frame:nil hand:nil] autorelease];
#else
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_pointable frame:nil hand:nil];
#endif
    return pointable;
}

@end;

//////////////////////////////////////////////////////////////////////////
//ARM
@implementation LeapArm
#if __has_feature(objc_arc)
{
    Leap::Arm *_interfaceArm;
}
#endif

- (id)initWithLeapArm:(void *)arm
{
    self = [super init];
    if (self) {
        _interfaceArm = new Leap::Arm(*(const Leap::Arm *)arm);
    }
    return self;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Arm";
    }
    return @"Arm";
}

- (LeapMatrix *)basis
{
    Leap::Matrix m = _interfaceArm->basis();
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithLeapMatrix:&m] autorelease];
#else
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
#endif
}

- (LeapVector *)center
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceArm->center().x y:_interfaceArm->center().y z:_interfaceArm->center().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceArm->center().x y:_interfaceArm->center().y z:_interfaceArm->center().z];
#endif
}

- (LeapVector *)direction
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceArm->direction().x y:_interfaceArm->direction().y z:_interfaceArm->direction().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceArm->direction().x y:_interfaceArm->direction().y z:_interfaceArm->direction().z];
#endif
}

- (BOOL)isValid
{
    return _interfaceArm->isValid();
}

- (LeapVector *)elbowPosition
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceArm->elbowPosition().x y:_interfaceArm->elbowPosition().y z:_interfaceArm->elbowPosition().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceArm->elbowPosition().x y:_interfaceArm->elbowPosition().y z:_interfaceArm->elbowPosition().z];
#endif
}

- (LeapVector *)wristPosition
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceArm->wristPosition().x y:_interfaceArm->wristPosition().y z:_interfaceArm->wristPosition().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceArm->wristPosition().x y:_interfaceArm->wristPosition().y z:_interfaceArm->wristPosition().z];
#endif
}

- (float)width
{
    return _interfaceArm->width();
}

+ (LeapArm *)invalid
{
    static const Leap::Arm &invalid_arm = Leap::Arm::invalid();
#if !__has_feature(objc_arc)
    LeapArm *arm = [[[LeapArm alloc] initWithLeapArm:(void *)&invalid_arm] autorelease];
#else
    LeapArm *arm = [[LeapArm alloc] initWithLeapArm:(void *)&invalid_arm];
#endif
    return arm;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif
    
@end

//////////////////////////////////////////////////////////////////////////
//BONE
@implementation LeapBone
#if __has_feature(objc_arc)
{
    Leap::Bone *_interfaceBone;
}
#endif

- (id)initWithLeapBone:(void *)bone
{
    self = [super init];
    if (self) {
        _interfaceBone = new Leap::Bone(*(const Leap::Bone *)bone);
    }
    return self;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Bone";
    }
    return [NSString stringWithFormat:@"Bone Type:%d", [self type]];
}

- (LeapMatrix *)basis
{
    Leap::Matrix m = _interfaceBone->basis();
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithLeapMatrix:&m] autorelease];
#else
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
#endif
}

- (LeapVector *)center
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceBone->center().x y:_interfaceBone->center().y z:_interfaceBone->center().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceBone->center().x y:_interfaceBone->center().y z:_interfaceBone->center().z];
#endif
}

- (LeapVector *)direction
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceBone->direction().x y:_interfaceBone->direction().y z:_interfaceBone->direction().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceBone->direction().x y:_interfaceBone->direction().y z:_interfaceBone->direction().z];
#endif
}

- (BOOL)isValid
{
    return _interfaceBone->isValid();
}

- (LeapVector *)prevJoint
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceBone->prevJoint().x y:_interfaceBone->prevJoint().y z:_interfaceBone->prevJoint().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceBone->prevJoint().x y:_interfaceBone->prevJoint().y z:_interfaceBone->prevJoint().z];
#endif
}

- (LeapVector *)nextJoint
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceBone->nextJoint().x y:_interfaceBone->nextJoint().y z:_interfaceBone->nextJoint().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceBone->nextJoint().x y:_interfaceBone->nextJoint().y z:_interfaceBone->nextJoint().z];
#endif
}

- (float)length
{
    return _interfaceBone->length();
}

- (float)width
{
    return _interfaceBone->width();
}

- (LeapBoneType)type
{
    return (LeapBoneType)_interfaceBone->type();
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (LeapBone *)invalid
{
    static const Leap::Bone &invalid_bone = Leap::Bone::invalid();
#if !__has_feature(objc_arc)
    LeapBone *bone = [[[LeapBone alloc] initWithLeapBone:(void *)&invalid_bone] autorelease];
#else
    LeapBone *bone = [[LeapBone alloc] initWithLeapBone:(void *)&invalid_bone];
#endif
    return bone;
}
    
@end

//////////////////////////////////////////////////////////////////////////
//FINGER
@implementation LeapFinger : LeapPointable

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Finger";
    }
    return [NSString stringWithFormat:@"Finger Id:%d", [self id]];
}

- (LeapVector *)jointPosition:(LeapFingerJoint)jointIx
{
    const Leap::Finger *finger = (const Leap::Finger *)[self interfacePointable];
    Leap::Vector v = finger->jointPosition((Leap::Finger::Joint)jointIx);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapBone *)bone:(LeapBoneType)type
{
    const Leap::Finger *finger = (const Leap::Finger *)[self interfacePointable];
    Leap::Bone b = finger->bone((Leap::Bone::Type)type);
#if !__has_feature(objc_arc)
    return [[[LeapBone alloc] initWithLeapBone:&b] autorelease];
#else
    return [[LeapBone alloc] initWithLeapBone:&b];
#endif
}

- (LeapFingerType)type
{
    const Leap::Finger *finger = (const Leap::Finger *)[self interfacePointable];
    return (LeapFingerType)finger->type();
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (LeapPointable *)invalid
{
    static const Leap::Finger &invalid_finger = Leap::Finger::invalid();
#if !__has_feature(objc_arc)
    LeapPointable *pointable = [[[LeapFinger alloc] initWithPointable:(void *)&invalid_finger frame:nil hand:nil] autorelease];
#else
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_finger frame:nil hand:nil];
#endif
    return pointable;
}

@end

//////////////////////////////////////////////////////////////////////////
//TOOL
@implementation LeapTool : LeapPointable

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Tool";
    }
    return [NSString stringWithFormat:@"Tool Id:%d", self.id];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (LeapPointable *)invalid
{
    static const Leap::Tool &invalid_tool = Leap::Tool::invalid();
#if !__has_feature(objc_arc)
    LeapPointable *pointable = [[[LeapFinger alloc] initWithPointable:(void *)&invalid_tool frame:nil hand:nil] autorelease];
#else
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_tool frame:nil hand:nil];
#endif
    return pointable;
}

@end

//////////////////////////////////////////////////////////////////////////
//HAND
@implementation LeapHand
#if __has_feature(objc_arc)
{
    Leap::Hand *_interfaceHand;
}
#endif

@synthesize frame = _frame;

- (id)initWithHand:(void *)hand frame:(LeapFrame *)frame
{
    self = [super init];
    if (self) {
        _interfaceHand = new Leap::Hand(*(const Leap::Hand *)hand);
        _frame = frame;
    }
    return self;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Hand";
    }
    return [NSString stringWithFormat:@"Hand Id:%d", [self id]];
}

- (int32_t)id
{
    return _interfaceHand->id();
}

- (NSArray *)pointables
{
    NSMutableArray *pointables_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->pointables().count(); i++) {
        const Leap::Pointable &tmpLeapPointable = _interfaceHand->pointables()[i];
        LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:_frame hand:self];
#if !__has_feature(objc_arc)
        [pointables_ar addObject:[pointable autorelease]];
#else
        [pointables_ar addObject:pointable];
#endif
    }
    return [NSArray arrayWithArray:pointables_ar];
}

- (NSArray *)fingers
{
    NSMutableArray *fingers_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->fingers().count(); i++) {
        const Leap::Finger &tmpLeapFinger = _interfaceHand->fingers()[i];
#if !__has_feature(objc_arc)
        LeapFinger *finger = [[[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self] autorelease];
#else
        LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self];
#endif
        [fingers_ar addObject:finger];
    }
    return [NSArray arrayWithArray:fingers_ar];
}

- (NSArray *)tools
{
    NSMutableArray *tools_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->tools().count(); i++) {
        const Leap::Tool &tmpLeapTool = _interfaceHand->tools()[i];
#if !__has_feature(objc_arc)
        LeapTool *tool = [[[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self] autorelease];
#else
        LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self];
#endif
        [tools_ar addObject:tool];
    }
    return [NSArray arrayWithArray:tools_ar];
}

- (LeapPointable *)pointable:(int32_t)pointableId
{
    const Leap::Pointable &tmpLeapPointable = _interfaceHand->pointable(pointableId);
#if !__has_feature(objc_arc)
    return [[[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:_frame hand:self] autorelease];
#else
    return [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:_frame hand:self];
#endif
}

- (LeapFinger *)finger:(int32_t)fingerId
{
    const Leap::Finger &tmpLeapFinger = _interfaceHand->finger(fingerId);
#if !__has_feature(objc_arc)
    return [[[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self] autorelease];
#else
    return [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self];
#endif
}

- (LeapTool *)tool:(int32_t)toolId
{
    const Leap::Tool &tmpLeapTool = _interfaceHand->tool(toolId);
#if !__has_feature(objc_arc)
    return [[[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self] autorelease];
#else
    return [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self];
#endif
}
- (LeapArm *)arm
{
    Leap::Arm arm = _interfaceHand->arm();
#if !__has_feature(objc_arc)
    return [[[LeapArm alloc] initWithLeapArm:&arm] autorelease];
#else
    return [[LeapArm alloc] initWithLeapArm:&arm];
#endif
}

- (LeapVector *)palmPosition
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->palmPosition().x y:_interfaceHand->palmPosition().y z:_interfaceHand->palmPosition().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->palmPosition().x y:_interfaceHand->palmPosition().y z:_interfaceHand->palmPosition().z];
#endif
}

- (LeapVector *)stabilizedPalmPosition
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->stabilizedPalmPosition().x y:_interfaceHand->stabilizedPalmPosition().y z:_interfaceHand->stabilizedPalmPosition().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->stabilizedPalmPosition().x y:_interfaceHand->stabilizedPalmPosition().y z:_interfaceHand->stabilizedPalmPosition().z];
#endif
}

- (LeapVector *)palmVelocity
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->palmVelocity().x y:_interfaceHand->palmVelocity().y z:_interfaceHand->palmVelocity().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->palmVelocity().x y:_interfaceHand->palmVelocity().y z:_interfaceHand->palmVelocity().z];
#endif
}

- (LeapVector *)palmNormal
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->palmNormal().x y:_interfaceHand->palmNormal().y z:_interfaceHand->palmNormal().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->palmNormal().x y:_interfaceHand->palmNormal().y z:_interfaceHand->palmNormal().z];
#endif
}

- (LeapVector *)direction
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->direction().x y:_interfaceHand->direction().y z:_interfaceHand->direction().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->direction().x y:_interfaceHand->direction().y z:_interfaceHand->direction().z];
#endif
}

- (LeapVector *)sphereCenter
{
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithX:_interfaceHand->sphereCenter().x y:_interfaceHand->sphereCenter().y z:_interfaceHand->sphereCenter().z] autorelease];
#else
    return [[LeapVector alloc] initWithX:_interfaceHand->sphereCenter().x y:_interfaceHand->sphereCenter().y z:_interfaceHand->sphereCenter().z];
#endif
}

- (float)sphereRadius
{
    return _interfaceHand->sphereRadius();
}

- (float) pinchStrength
{
    return _interfaceHand->pinchStrength();
}

- (float) grabStrength
{
    return _interfaceHand->grabStrength();
}

- (LeapMatrix *)basis
{
    Leap::Matrix m = _interfaceHand->basis();
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithLeapMatrix:&m] autorelease];
#else
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
#endif
}

- (float)palmWidth
{
    return _interfaceHand->palmWidth();
}

- (BOOL)isValid
{
    return _interfaceHand->isValid();
}

- (LeapFrame *)frame
{
    NSAssert(_frame != nil, @"Hand's frame has been deallocated due to weak ARC reference. Retain a strong pointer to this frame if you wish to access it later.");
    return _frame;
}

- (void)dealloc
{
    delete _interfaceHand;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (LeapVector *)translation:(const LeapFrame *)sinceFrame
{
    Leap::Vector v = _interfaceHand->translation(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (float)translationProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceHand->translationProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (LeapVector *)rotationAxis:(const LeapFrame *)sinceFrame
{
    Leap::Vector v = _interfaceHand->rotationAxis(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (float)rotationAngle:(const LeapFrame *)sinceFrame
{
    return _interfaceHand->rotationAngle(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)sinceFrame axis:(const LeapVector *)axis
{
    const Leap::Vector v([axis x], [axis y], [axis z]);
    return _interfaceHand->rotationAngle(*(const Leap::Frame *)[sinceFrame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)sinceFrame
{
    Leap::Matrix m = _interfaceHand->rotationMatrix(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithLeapMatrix:&m] autorelease];
#else
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
#endif
}

- (float)rotationProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceHand->rotationProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)scaleFactor:(const LeapFrame *)sinceFrame
{
    return _interfaceHand->scaleFactor(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)scaleProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceHand->scaleProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)timeVisible
{
    return _interfaceHand->timeVisible();
}

- (float)confidence
{
    return _interfaceHand->confidence();
}

- (BOOL)isLeft
{
    return _interfaceHand->isLeft();
}

- (BOOL)isRight
{
    return _interfaceHand->isRight();
}

+ (LeapHand *)invalid
{
    static const Leap::Hand &invalid_hand = Leap::Hand::invalid();
#if !__has_feature(objc_arc)
    LeapHand *hand = [[[LeapHand alloc] initWithHand:(void *)&invalid_hand frame:nil] autorelease];
#else
    LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&invalid_hand frame:nil];
#endif
    return hand;
}

@end;

//////////////////////////////////////////////////////////////////////////
//SCREEN
@implementation LeapScreen
#if __has_feature(objc_arc)
{
    Leap::Screen *_interfaceScreen;
}
#endif

- (id)initWithScreen:(void *)screen
{
    self = [super init];
    if (self) {
        _interfaceScreen = new Leap::Screen(*(const Leap::Screen *)screen);
    }
    return self;
}

- (NSString *)description
{
    const std::string str = _interfaceScreen->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceScreen
{
    return (void *)_interfaceScreen;
}

- (int32_t)id
{
    return _interfaceScreen->id();
}

- (LeapVector *)intersect:(LeapPointable *)pointable normalize:(BOOL)normalize clampRatio:(float)clampRatio
{
    const Leap::Pointable *leapPointable = (const Leap::Pointable *)[pointable interfacePointable];
    Leap::Vector v = _interfaceScreen->intersect(*leapPointable, normalize, clampRatio);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)intersect:(LeapVector *)position direction:(LeapVector *)direction normalize:(BOOL)normalize clampRatio:(float)clampRatio
{
    const Leap::Vector leapPosition([position x], [position y], [position z]);
    const Leap::Vector leapDirection([direction x], [direction y], [direction z]);
    Leap::Vector v = _interfaceScreen->intersect(leapPosition, leapDirection, normalize, clampRatio);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)project:(LeapVector *)position normalize:(BOOL)normalize clampRatio:(float)clampRatio
{
    const Leap::Vector leapPosition([position x], [position y], [position z]);
    Leap::Vector v = _interfaceScreen->project(leapPosition, normalize, clampRatio);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)horizontalAxis
{
    Leap::Vector v = _interfaceScreen->horizontalAxis();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)verticalAxis
{
    Leap::Vector v = _interfaceScreen->verticalAxis();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)bottomLeftCorner
{
    Leap::Vector v = _interfaceScreen->bottomLeftCorner();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (LeapVector *)normal
{
    Leap::Vector v = _interfaceScreen->normal();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (int)widthPixels
{
    return _interfaceScreen->widthPixels();
}

- (int)heightPixels
{
    return _interfaceScreen->heightPixels();
}

- (float)distanceToPoint:(const LeapVector *)point
{
    const Leap::Vector p([point x], [point y], [point z]);
    return _interfaceScreen->distanceToPoint(p);
}

- (BOOL)isValid
{
    return _interfaceScreen->isValid();
}

- (BOOL)equals:(const LeapScreen *)other
{
    return *_interfaceScreen == *(const Leap::Screen *)[other interfaceScreen];
}

- (void)dealloc
{
    delete _interfaceScreen;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (LeapScreen *)invalid
{
    static const Leap::Screen &invalid_screen = Leap::Screen::invalid();
#if !__has_feature(objc_arc)
    return [[[LeapScreen alloc] initWithScreen:(void *)&invalid_screen] autorelease];
#else
    return [[LeapScreen alloc] initWithScreen:(void *)&invalid_screen];
#endif
}

@end;


//////////////////////////////////////////////////////////////////////////
//DEVICE
@implementation LeapDevice
#if __has_feature(objc_arc)
{
    Leap::Device *_interfaceDevice;
}
#endif

- (id)initWithDevice:(void *)device
{
    self = [super init];
    if (self) {
        _interfaceDevice = new Leap::Device(*(const Leap::Device *)device);
    }
    return self;
}

- (NSString *)description
{
    std::string str = _interfaceDevice->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceDevice
{
    return (void *)_interfaceDevice;
}

- (float)horizontalViewAngle
{
    return _interfaceDevice->horizontalViewAngle();
}

- (float)verticalViewAngle
{
    return _interfaceDevice->verticalViewAngle();
}

- (float)range
{
    return _interfaceDevice->range();
}

- (float)distanceToBoundary:(const LeapVector *)position;
{
    Leap::Vector v([position x], [position y], [position z]);
    return _interfaceDevice->distanceToBoundary(v);
}

- (BOOL)isEmbedded
{
    return _interfaceDevice->isEmbedded();
}

- (BOOL)isStreaming
{
    return _interfaceDevice->isStreaming();
}

- (LeapDeviceType)type
{
    return (LeapDeviceType)_interfaceDevice->type();
}

- (BOOL)isValid
{
    return _interfaceDevice->isValid();
}

- (BOOL)equals:(const LeapDevice *)other
{
    return *_interfaceDevice == *(const Leap::Device *)[other interfaceDevice];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (LeapDevice *)invalid
{
    static const Leap::Device &invalid_device = Leap::Device::invalid();
#if !__has_feature(objc_arc)
    return [[[LeapDevice alloc] initWithDevice:(void *)&invalid_device] autorelease];
#else
    return [[LeapDevice alloc] initWithDevice:(void *)&invalid_device];
#endif
}

@end


//////////////////////////////////////////////////////////////////////////
//INTERACTIONBOX
@implementation LeapInteractionBox
#if __has_feature(objc_arc)
{
    Leap::InteractionBox *_interfaceInteractionBox;
}
#endif

- (id)initWithInteractionBox:(void *)interactionBox
{
    self = [super init];
    if (self) {
        _interfaceInteractionBox = new Leap::InteractionBox(*(const Leap::InteractionBox *)interactionBox);
    }
    return self;
}

- (NSString *)description
{
    std::string str = _interfaceInteractionBox->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceInteractionBox
{
    return (void *)_interfaceInteractionBox;
}

- (LeapVector *)normalizePoint:(const LeapVector *)position clamp:(BOOL)clamp
{
    const Leap::Vector v([position x], [position y], [position z]);
    const Leap::Vector leapVector = _interfaceInteractionBox->normalizePoint(v, clamp);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)denormalizePoint:(const LeapVector *)position
{
    const Leap::Vector v([position x], [position y], [position z]);
    const Leap::Vector leapVector = _interfaceInteractionBox->denormalizePoint(v);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)center
{
    const Leap::Vector leapVector = _interfaceInteractionBox->center();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)width
{
    return _interfaceInteractionBox->width();
}

- (float)height
{
    return _interfaceInteractionBox->height();
}

- (float)depth
{
    return _interfaceInteractionBox->depth();
}

- (BOOL)isValid
{
    return _interfaceInteractionBox->isValid();
}

- (BOOL)equals:(const LeapInteractionBox *)other
{
    return *_interfaceInteractionBox == *(const Leap::InteractionBox *)[other interfaceInteractionBox];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

+ (LeapInteractionBox *)invalid
{
    static const Leap::InteractionBox &invalid_interaction_box = Leap::InteractionBox::invalid();
#if !__has_feature(objc_arc)
    return [[[LeapInteractionBox alloc] initWithInteractionBox:(void *)&invalid_interaction_box] autorelease];
#else
    return [[LeapInteractionBox alloc] initWithInteractionBox:(void *)&invalid_interaction_box];
#endif
}

@end


/////////////////////////////////////////////////////////////////////////
//GESTURE
@interface LeapGesture ()
@property (nonatomic, strong, readonly)NSDictionary *handFromID;
@end

@implementation LeapGesture
#if __has_feature(objc_arc)
{
    Leap::Gesture *_interfaceGesture;
}
#endif

@synthesize frame = _frame;
@synthesize hands = _hands;
@synthesize pointables = _pointables;
@synthesize handFromID = _handFromID;

- (id)initWithGesture:(void *)leapGesture frame:(LeapFrame *)frame
{
    self = [super init];
    if (self) {
#if !__has_feature(objc_arc)
        NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
#else
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
#endif
        switch(((const Leap::Gesture *)leapGesture)->type()) {
            case LEAP_GESTURE_TYPE_SWIPE:
                _interfaceGesture = new Leap::SwipeGesture(*(const Leap::SwipeGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_CIRCLE:
                _interfaceGesture = new Leap::CircleGesture(*(const Leap::CircleGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_SCREEN_TAP:
                _interfaceGesture = new Leap::ScreenTapGesture(*(const Leap::ScreenTapGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_KEY_TAP:
                _interfaceGesture = new Leap::KeyTapGesture(*(const Leap::KeyTapGesture *)leapGesture);
                break;
            default:
                _interfaceGesture = new Leap::Gesture(*(const Leap::Gesture *)leapGesture);
        }
        _frame = frame;

        NSMutableArray *hands_ar = [NSMutableArray array];
        for (int i = 0; i < _interfaceGesture->hands().count(); i++) {
            const Leap::Hand &tmpLeapHand = _interfaceGesture->hands()[i];
#if !__has_feature(objc_arc)
            LeapHand *hand = [[[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:frame] autorelease];
#else
            LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:frame];
#endif
            [hands_ar addObject:hand];
            [dictionary setObject:hand forKey:[NSNumber numberWithUnsignedInteger:tmpLeapHand.id()]];
        }
        _hands = [NSArray arrayWithArray:hands_ar];

        NSMutableArray *pointables_ar = [NSMutableArray array];
        for (int i = 0; i < _interfaceGesture->pointables().count(); i++) {
            const Leap::Pointable &tmpLeapPointable = _interfaceGesture->pointables()[i];
            LeapHand *hand;
            if (tmpLeapPointable.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapPointable.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
#if !__has_feature(objc_arc)
            LeapPointable *pointable = [[[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:frame hand:hand] autorelease];
#else
            LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:frame hand:hand];
#endif
            [pointables_ar addObject:pointable];
        }
        _pointables = [NSArray arrayWithArray:pointables_ar];
        _handFromID = [NSDictionary dictionaryWithDictionary:dictionary];
#if !__has_feature(objc_arc)
        [_pointables retain];
        [_handFromID retain];
#endif
    }
    return self;
}

- (NSString *)description
{
    std::string str = _interfaceGesture->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceGesture
{
    return (void *)_interfaceGesture;
}

- (LeapGestureType)type
{
    return (LeapGestureType)_interfaceGesture->type();
}

- (LeapGestureState)state
{
    return (LeapGestureState)_interfaceGesture->state();
}

- (int32_t)id
{
    return _interfaceGesture->id();
}

- (int64_t)duration
{
    return _interfaceGesture->duration();
}

- (float)durationSeconds
{
    return _interfaceGesture->durationSeconds();
}

- (BOOL)isValid
{
    return _interfaceGesture->isValid();
}

- (BOOL)equals:(const LeapGesture *)other
{
    return *_interfaceGesture == *(const Leap::Gesture *)[other interfaceGesture];
}

- (void)dealloc
{
    delete _interfaceGesture;
#if !__has_feature(objc_arc)
    [_pointables release];
    [_handFromID release];
    [super dealloc];
#endif
}

+ (LeapGesture *)invalid
{
    static const Leap::Gesture &invalid_gesture = Leap::Gesture::invalid();
#if !__has_feature(objc_arc)
    return [[[LeapGesture alloc] initWithGesture:(void *)&invalid_gesture frame:nil] autorelease];
#else
    return [[LeapGesture alloc] initWithGesture:(void *)&invalid_gesture frame:nil];
#endif
}

@end


//////////////////////////////////////////////////////////////////////////
//SWIPE GESTURE
@implementation LeapSwipeGesture : LeapGesture

- (LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->position();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)startPosition
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->startPosition();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->direction();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)speed
{
    return ((const Leap::SwipeGesture *)[self interfaceGesture])->speed();
}

- (LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::SwipeGesture *)[self interfaceGesture])->pointable();
    const Leap::Hand &leapHand = leapPointable.hand();
    LeapHand *hand = [[self handFromID] objectForKey:[NSNumber numberWithUnsignedInteger:leapHand.id()]];
    if (hand == nil) {
        hand = [LeapHand invalid];
    }
#if !__has_feature(objc_arc)
    return [[[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand] autorelease];
#else
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand];
#endif
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif
@end

//////////////////////////////////////////////////////////////////////////
//CIRCLE GESTURE
@implementation LeapCircleGesture : LeapGesture

- (float)progress
{
    return ((const Leap::CircleGesture *)[self interfaceGesture])->progress();
}

- (LeapVector *)center
{
    const Leap::Vector &leapVector = ((const Leap::CircleGesture *)[self interfaceGesture])->center();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)normal
{
    const Leap::Vector &leapVector = ((const Leap::CircleGesture *)[self interfaceGesture])->normal();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)radius
{
    return ((const Leap::CircleGesture *)[self interfaceGesture])->radius();
}

- (LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::CircleGesture *)[self interfaceGesture])->pointable();
    const Leap::Hand &leapHand = leapPointable.hand();
    LeapHand *hand = [[self handFromID] objectForKey:[NSNumber numberWithUnsignedInteger:leapHand.id()]];
    if (hand == nil) {
        hand = [LeapHand invalid];
    }
#if !__has_feature(objc_arc)
    return [[[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand] autorelease];
#else
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand];
#endif
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

@end

//////////////////////////////////////////////////////////////////////////
//SCREEN TAP GESTURE
@implementation LeapScreenTapGesture : LeapGesture

- (LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->position();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->direction();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)progress
{
    return ((const Leap::ScreenTapGesture *)[self interfaceGesture])->progress();
}

- (LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->pointable();
    const Leap::Hand &leapHand = leapPointable.hand();
    LeapHand *hand = [[self handFromID] objectForKey:[NSNumber numberWithUnsignedInteger:leapHand.id()]];
    if (hand == nil) {
        hand = [LeapHand invalid];
    }
#if !__has_feature(objc_arc)
    return [[[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand] autorelease];
#else
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand];
#endif
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

@end

//////////////////////////////////////////////////////////////////////////
//KEY TAP GESTURE
@implementation LeapKeyTapGesture : LeapGesture

- (LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::KeyTapGesture *)[self interfaceGesture])->position();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::KeyTapGesture *)[self interfaceGesture])->direction();
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z] autorelease];
#else
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
#endif
}

- (float)progress
{
    return ((const Leap::KeyTapGesture *)[self interfaceGesture])->progress();
}

- (LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::KeyTapGesture *)[self interfaceGesture])->pointable();
    const Leap::Hand &leapHand = leapPointable.hand();
    LeapHand *hand = [[self handFromID] objectForKey:[NSNumber numberWithUnsignedInteger:leapHand.id()]];
    if (hand == nil) {
        hand = [LeapHand invalid];
    }
#if !__has_feature(objc_arc)
    return [[[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand] autorelease];
#else
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:hand];
#endif
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

@end

//////////////////////////////////////////////////////////////////////////
//FRAME
@implementation LeapFrame
#if __has_feature(objc_arc)
{
    Leap::Frame *_interfaceFrame;
}
#endif

@synthesize hands = _hands;
@synthesize pointables = _pointables;
@synthesize fingers = _fingers;
@synthesize tools = _tools;

- (id)initWithFrame:(const void *)frame
{
    self = [super init];
    if (self) {
        _interfaceFrame = new Leap::Frame(*(const Leap::Frame *)frame);
#if !__has_feature(objc_arc)
        NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
#else
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
#endif
        Leap::Frame leapFrame = *(Leap::Frame *)frame;

        NSMutableArray *hands_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.hands().count(); i++) {
            const Leap::Hand &tmpLeapHand = leapFrame.hands()[i];
#if !__has_feature(objc_arc)
            LeapHand *hand = [[[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:self] autorelease];
#else
            LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:self];
#endif
            [hands_ar addObject:hand];
            [dictionary setObject:hand forKey:[NSNumber numberWithUnsignedInteger:tmpLeapHand.id()]];
        }
        _hands = [NSArray arrayWithArray:hands_ar];

        NSMutableArray *pointables_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.pointables().count(); i++) {
            const Leap::Pointable &tmpLeapPointable = leapFrame.pointables()[i];
            LeapHand *hand;
            if (tmpLeapPointable.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapPointable.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
#if !__has_feature(objc_arc)
            LeapPointable *pointable = [[[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:self hand:hand] autorelease];
#else
            LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:self hand:hand];
#endif
            [pointables_ar addObject:pointable];
        }
        _pointables = [NSArray arrayWithArray:pointables_ar];

        NSMutableArray *fingers_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.fingers().count(); i++) {
            const Leap::Finger &tmpLeapFinger = leapFrame.fingers()[i];
            LeapHand *hand;
            if (tmpLeapFinger.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapFinger.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
#if !__has_feature(objc_arc)
            LeapFinger *finger = [[[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:self hand:hand] autorelease];
#else
            LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:self hand:hand];
#endif
            [fingers_ar addObject:finger];
        }
        _fingers = [NSArray arrayWithArray:fingers_ar];

        NSMutableArray *tools_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.tools().count(); i++) {
            const Leap::Tool &tmpLeapTool = leapFrame.tools()[i];
            LeapHand *hand;
            if (tmpLeapTool.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapTool.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
#if !__has_feature(objc_arc)
            LeapTool *tool = [[[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:self hand:hand] autorelease];
#else
            LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:self hand:hand];
#endif
            [tools_ar addObject:tool];
        }
        _tools = [NSArray arrayWithArray:tools_ar];
        
#if !__has_feature(objc_arc)
        [_hands retain];
        [_pointables retain];
        [_fingers retain];
        [_tools retain];
#endif
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Frame Id:%lld", self.id];
}

- (void *)interfaceFrame
{
    return (void *)_interfaceFrame;
}

- (int64_t)id
{
    return _interfaceFrame->id();
}

- (int64_t)timestamp
{
    return _interfaceFrame->timestamp();
}

- (LeapHand *)hand:(int32_t)handId
{
    NSEnumerator *e = [_hands objectEnumerator];
    LeapHand *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == handId) {
            return obj;
        }
    }
    return [LeapHand invalid];
}

- (LeapPointable *)pointable:(int32_t)pointableId
{
    NSEnumerator *e = [_pointables objectEnumerator];
    LeapPointable *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == pointableId) {
            return obj;
        }
    }
    return [LeapPointable invalid];
}

- (LeapPointable *)finger:(int32_t)fingerId
{
    NSEnumerator *e = [_fingers objectEnumerator];
    LeapFinger *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == fingerId) {
            return obj;
        }
    }
    return [LeapFinger invalid];
}

- (LeapPointable *)tool:(int32_t)toolId
{
    NSEnumerator *e = [_tools objectEnumerator];
    LeapTool *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == toolId) {
            return obj;
        }
    }
    return [LeapTool invalid];
}

- (void)dealloc
{
    delete _interfaceFrame;
#if !__has_feature(objc_arc)
    [_hands release];
    [_pointables release];
    [_fingers release];
    [_tools release];
    [super dealloc];
#endif
}

- (LeapGesture *)typedGestureCreate:(void *)leapGesture
{
    LeapGesture *gesture;
    switch(((const Leap::Gesture *)leapGesture)->type()) {
        case LEAP_GESTURE_TYPE_SWIPE:
            gesture = [LeapSwipeGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_CIRCLE:
            gesture = [LeapCircleGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_SCREEN_TAP:
            gesture = [LeapScreenTapGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_KEY_TAP:
            gesture = [LeapKeyTapGesture alloc];
            break;
        default:
            gesture = [LeapGesture alloc];
    }
#if !__has_feature(objc_arc)
    return [[gesture initWithGesture:leapGesture frame:self] autorelease];
#else
    return [gesture initWithGesture:leapGesture frame:self];
#endif
}

- (NSArray *)gestures:(const LeapFrame *)sinceFrame
{
    Leap::GestureList leapGestures = (sinceFrame == nil ?
                                      _interfaceFrame->gestures() :
                                      _interfaceFrame->gestures(*(Leap::Frame*)[sinceFrame interfaceFrame]));
    NSMutableArray *gestures_ar = [NSMutableArray array];
    for (Leap::GestureList::const_iterator it = leapGestures.begin(); it != leapGestures.end(); ++it) {
        const Leap::Gesture leapGesture = *it;
        LeapGesture *gesture = [self typedGestureCreate:(void *)&leapGesture];
        [gestures_ar addObject:gesture];
    }
    return [NSArray arrayWithArray:gestures_ar];
}

- (LeapGesture *)gesture:(int32_t) gestureId
{
    Leap::Gesture leapGesture = _interfaceFrame->gesture(gestureId);
    return [self typedGestureCreate:(void *)&leapGesture];
}

- (LeapVector *)translation:(const LeapFrame *)sinceFrame
{
    Leap::Vector v = _interfaceFrame->translation(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (float)translationProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceFrame->translationProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (LeapVector *)rotationAxis:(const LeapFrame *)sinceFrame
{
    Leap::Vector v = _interfaceFrame->rotationAxis(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapVector alloc] initWithLeapVector:&v] autorelease];
#else
    return [[LeapVector alloc] initWithLeapVector:&v];
#endif
}

- (float)rotationAngle:(const LeapFrame *)sinceFrame
{
    return _interfaceFrame->rotationAngle(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)sinceFrame axis:(const LeapVector *)axis
{
    Leap::Vector v([axis x], [axis y], [axis z]);
    return _interfaceFrame->rotationAngle(*(const Leap::Frame *)[sinceFrame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)sinceFrame
{
    Leap::Matrix m = _interfaceFrame->rotationMatrix(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
#if !__has_feature(objc_arc)
    return [[[LeapMatrix alloc] initWithLeapMatrix:&m] autorelease];
#else
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
#endif
}

- (float)rotationProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceFrame->rotationProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)scaleFactor:(const LeapFrame *)sinceFrame
{
    return _interfaceFrame->scaleFactor(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (float)scaleProbability:(const LeapFrame *)sinceFrame
{
    return _interfaceFrame->scaleProbability(*(const Leap::Frame *)[sinceFrame interfaceFrame]);
}

- (LeapInteractionBox *)interactionBox
{
    const Leap::InteractionBox leapInteractionBox = _interfaceFrame->interactionBox();
#if !__has_feature(objc_arc)
    return [[[LeapInteractionBox alloc] initWithInteractionBox:(void *)&leapInteractionBox] autorelease];
#else
    return [[LeapInteractionBox alloc] initWithInteractionBox:(void *)&leapInteractionBox];
#endif
}

- (float)currentFramesPerSecond
{
    return _interfaceFrame->currentFramesPerSecond();
}

- (BOOL)isValid
{
    return _interfaceFrame->isValid();
}

+ (LeapFrame *)invalid
{
    static const Leap::Frame &invalid_frame = Leap::Frame::invalid();
#if !__has_feature(objc_arc)
    return [[[LeapFrame alloc]initWithFrame:(void *)&invalid_frame] autorelease];
#else
    return [[LeapFrame alloc]initWithFrame:(void *)&invalid_frame];
#endif
}

@end;

//////////////////////////////////////////////////////////////////////////
//CONFIG
@implementation LeapConfig
#if __has_feature(objc_arc)
{
    Leap::Config _config;
}
#endif

- (id)initWithConfig:(void *)config
{
    self = [super init];
    if (self) {
        _config = *(Leap::Config *)config;
    }
    return self;
}

- (LeapValueType)convertFromLeapValueType:(Leap::Config::ValueType)val
{
    switch(val) {
        case Leap::Config::TYPE_UNKNOWN:
            return TYPE_UNKNOWN;
        case Leap::Config::TYPE_BOOLEAN:
            return TYPE_BOOLEAN;
        case Leap::Config::TYPE_INT32:
            return TYPE_INT32;
        case Leap::Config::TYPE_FLOAT:
            return TYPE_FLOAT;
        case Leap::Config::TYPE_STRING:
            return TYPE_STRING;
        default:
            return TYPE_UNKNOWN;
    }
}

- (LeapValueType)type:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    Leap::Config::ValueType val = _config.type(*keyString);
    delete keyString;
    return [self convertFromLeapValueType:val];
}

- (BOOL)getBool:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL val = _config.getBool(*keyString);
    delete keyString;
    return val;
}

- (BOOL)setBool:(NSString *)key value:(BOOL)value
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL success = _config.setBool(*keyString, bool(value));
    delete keyString;
    return success;
}

- (int32_t)getInt32:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    int32_t val = _config.getInt32(*keyString);
    delete keyString;
    return val;
}

- (BOOL)setInt32:(NSString *)key value:(int32_t)value
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL success = _config.setInt32(*keyString, value);
    delete keyString;
    return success;
}

- (float)getFloat:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    float val = _config.getFloat(*keyString);
    delete keyString;
    return val;
}

- (BOOL)setFloat:(NSString *)key value:(float)value
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL success = _config.setFloat(*keyString, value);
    delete keyString;
    return success;
}

- (NSString *)getString:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    std::string str = _config.getString(*keyString);
#if !__has_feature(objc_arc)
    NSString *val = [[[NSString alloc] initWithUTF8String:str.c_str()] autorelease];
#else
    NSString *val = [[NSString alloc] initWithUTF8String:str.c_str()];
#endif
    delete keyString;
    return val;
}

- (BOOL)setString:(NSString *)key value:(NSString *)value
{
    std::string *keyString = new std::string([key UTF8String]);
    std::string *valueString = new std::string([value UTF8String]);
    BOOL success = _config.setString(*keyString, *valueString);
    delete keyString;
    delete valueString;
    return success;
}

- (BOOL)save
{
    return BOOL(_config.save());
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

@end;

//////////////////////////////////////////////////////////////////////////
//NOTIFICATION LISTENER
class LeapNotificationListener : public Leap::Listener
{
public:
    virtual void onInit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnInit" object:_controller];
        }
    }

    virtual void onConnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnConnect" object:_controller];
        }
    }

    virtual void onDisconnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnDisconnect" object:_controller];
        }
    }

    virtual void onServiceConnect(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnServiceConnect" object:_controller];
      }
    }

    virtual void onServiceDisconnect(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnServiceDisconnect" object:_controller];
      }
    }

    virtual void onDeviceChange(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnDeviceChange" object:_controller];
      }
    }

    virtual void onExit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnExit" object:_controller];
        }
    }

    virtual void onFrame(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnFrame" object:_controller];
        }
    }

    virtual void onFocusGained(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnFocusGained" object:_controller];
        }
    }

    virtual void onFocusLost(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnFocusLost" object:_controller];
        }
    }

    void setController(LeapController *controller)
    {
        _controller = controller;
    }

private:
    LeapController *_controller;
};

//////////////////////////////////////////////////////////////////////////
//DELEGATE LISTENER
class LeapDelegateListener : public Leap::Listener
{
public:
    virtual void onInit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onInit:)]) {
                [_delegate onInit:_controller];
            }
        }
    }

    virtual void onConnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onConnect:)]) {
                [_delegate onConnect:_controller];
            }
        }
    }

    virtual void onDisconnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onDisconnect:)]) {
                [_delegate onDisconnect:_controller];
            }
        }
    }

    virtual void onServiceConnect(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        if ([_delegate respondsToSelector:@selector(onServiceConnect:)]) {
          [_delegate onServiceConnect:_controller];
        }
      }
    }

    virtual void onServiceDisconnect(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        if ([_delegate respondsToSelector:@selector(onServiceDisconnect:)]) {
          [_delegate onServiceDisconnect:_controller];
        }
      }
    }

    virtual void onDeviceChange(const Leap::Controller& leapController)
    {
      @autoreleasepool {
        if ([_delegate respondsToSelector:@selector(onDeviceChange:)]) {
          [_delegate onDeviceChange:_controller];
        }
      }
    }

    virtual void onExit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onExit:)]) {
                [_delegate onExit:_controller];
            }
        }
    }

    virtual void onFrame(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onFrame:)]) {
                [_delegate onFrame:_controller];
            }
        }
    }

    virtual void onFocusGained(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onFocusGained:)]) {
                [_delegate onFocusGained:_controller];
            }
        }
    }

    virtual void onFocusLost(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onFocusLost:)]) {
                [_delegate onFocusLost:_controller];
            }
        }
    }

    void setController(LeapController *controller)
    {
        _controller = controller;
    }

    void initWithDelegate(id<LeapDelegate> delegate)
    {
        _delegate = delegate;
    }

    id<LeapDelegate> _delegate;
private:
    LeapController *_controller;
};

//////////////////////////////////////////////////////////////////////////
//CONTROLLER
@implementation LeapController
#if __has_feature(objc_arc)
{
    Leap::Controller *_controller;
    Leap::Listener *_listener;
}
#endif

// initWithController is used only by the wrapper
- (id)initWithController:(void *)controller
{
    self = [super init];
    if (self) {
        _controller = (Leap::Controller *)controller;
        _listener = NULL;
    }
    return self;
}

// init and initWithDelegate may be called by the user
- (id)init
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        _controller = new Leap::Controller();
        _listener = NULL;
    }
    return self;
}

- (id)initWithListener:(id<LeapListener>)leapListener
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        LeapNotificationListener *notificationListener = new LeapNotificationListener();
        notificationListener->setController(self);
        _listener = notificationListener;
        _controller = new Leap::Controller(*_listener);

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        if ([leapListener respondsToSelector:@selector(onInit:)]) {
            [nc addObserver:leapListener selector:@selector(onInit:) name:@"OnInit" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onConnect:)]) {
            [nc addObserver:leapListener selector:@selector(onConnect:) name:@"OnConnect" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onDisconnect:)]) {
            [nc addObserver:leapListener selector:@selector(onDisconnect:) name:@"OnDisconnect" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onServiceConnect:)]) {
            [nc addObserver:leapListener selector:@selector(onServiceConnect:)   name:@"OnServiceConnect" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onServiceDisconnect:)]) {
            [nc addObserver:leapListener selector:@selector(onServiceDisconnect:) name:@"OnServiceDisconnect" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onDeviceChange:)]) {
            [nc addObserver:leapListener selector:@selector(onDeviceChange:) name:@"OnDeviceChange" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onExit:)]) {
            [nc addObserver:leapListener selector:@selector(onExit:) name:@"OnExit" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onFrame:)]) {
            [nc addObserver:leapListener selector:@selector(onFrame:) name:@"OnFrame" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onFocusGained:)]) {
            [nc addObserver:leapListener selector:@selector(onFocusGained:) name:@"OnFocusGained" object:self];
        }
        if ([leapListener respondsToSelector:@selector(onFocusLost:)]) {
            [nc addObserver:leapListener selector:@selector(onFocusLost:) name:@"OnFocusLost" object:self];
        }

    }
    return self;
}

- (LeapPolicyFlag)policyFlags
{
    return (LeapPolicyFlag)_controller->policyFlags();
}

- (void)setPolicyFlags:(LeapPolicyFlag)flags
{
    _controller->setPolicyFlags((Leap::Controller::PolicyFlag)flags);
}

- (BOOL)addListener:(id<LeapListener>)listener
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if ([listener respondsToSelector:@selector(onInit:)]) {
        [nc addObserver:listener selector:@selector(onInit:) name:@"OnInit" object:self];
    }
    if ([listener respondsToSelector:@selector(onConnect:)]) {
        [nc addObserver:listener selector:@selector(onConnect:) name:@"OnConnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onDisconnect:)]) {
        [nc addObserver:listener selector:@selector(onDisconnect:) name:@"OnDisconnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onServiceConnect:)]) {
      [nc addObserver:listener selector:@selector(onServiceConnect:) name:@"OnServiceConnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onServiceDisconnect:)]) {
      [nc addObserver:listener selector:@selector(onServiceDisconnect:) name:@"OnServiceDisconnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onDeviceChange:)]) {
      [nc addObserver:listener selector:@selector(onDeviceChange:) name:@"OnDeviceChange" object:self];
    }
    if ([listener respondsToSelector:@selector(onExit:)]) {
        [nc addObserver:listener selector:@selector(onExit:) name:@"OnExit" object:self];
    }
    if ([listener respondsToSelector:@selector(onFrame:)]) {
        [nc addObserver:listener selector:@selector(onFrame:) name:@"OnFrame" object:self];
    }
    if ([listener respondsToSelector:@selector(onFocusGained:)]) {
        [nc addObserver:listener selector:@selector(onFocusGained:) name:@"OnFocusGained" object:self];
    }
    if ([listener respondsToSelector:@selector(onFocusLost:)]) {
        [nc addObserver:listener selector:@selector(onFocusLost:) name:@"OnFocusLost" object:self];
    }

    if (!_listener) {
        LeapNotificationListener *notificationListener = new LeapNotificationListener();
        notificationListener->setController(self);
        _listener = notificationListener;
        _controller->addListener(*notificationListener);
        // note: Because we use a single C++ Leap::Listener per controller under the hood, if you
        // have more than one LeapListener, only the first will receive @"OnInit"
    }
    return TRUE;
}

- (BOOL)removeListener:(id<LeapListener>)listener
{
    [[NSNotificationCenter defaultCenter] removeObserver:listener];
    return TRUE;
}

- (id)initWithDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        LeapDelegateListener *delegateListener = new LeapDelegateListener();
        delegateListener->initWithDelegate(leapDelegate);
        delegateListener->setController(self);
        _listener = delegateListener;
        _controller = new Leap::Controller(*_listener);
    }
    return self;
}

- (BOOL)addDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(_listener == NULL, @"Delegates are one-to-one, cannot have more than one LeapDelegate per LeapController. Use the LeapListener object for the NSNotification pattern instead. (And no mixing of delegates and the LeapListener NSNotification pattern on a single controller)");
    LeapDelegateListener *delegateListener = new LeapDelegateListener();
    delegateListener->initWithDelegate(leapDelegate);
    delegateListener->setController(self);
    _listener = delegateListener;
    _controller->addListener(*_listener);
    return TRUE;
}

- (BOOL)removeDelegate
{
    NSAssert(_listener, @"Must call addDelegate before trying to remove a LeapDelegate");
    _controller->removeListener(*_listener);
    _listener = NULL;
    return TRUE;
}

- (LeapFrame *)frame:(int)history
{
    Leap::Frame leapFrame = _controller->frame(history);
#if !__has_feature(objc_arc)
    LeapFrame *frame = [[[LeapFrame alloc] initWithFrame:(void *)&leapFrame] autorelease];
#else
    LeapFrame *frame = [[LeapFrame alloc] initWithFrame:(void *)&leapFrame];
#endif
    return frame;
}

- (LeapConfig *)config;
{
    Leap::Config leapConfig = _controller->config();
#if !__has_feature(objc_arc)
    LeapConfig *config = [[[LeapConfig alloc] initWithConfig:(void *)&leapConfig] autorelease];
#else
    LeapConfig *config = [[LeapConfig alloc] initWithConfig:(void *)&leapConfig];
#endif
    return config;
}

- (NSArray *)devices
{
    Leap::DeviceList leapDevices = _controller->devices();
    NSMutableArray *devices_ar = [NSMutableArray array];
    for (Leap::DeviceList::const_iterator it = leapDevices.begin(); it != leapDevices.end(); ++it) {
        Leap::Device leapDevice = *it;
#if !__has_feature(objc_arc)
        LeapDevice *device = [[[LeapDevice alloc] initWithDevice:(void *)&leapDevice] autorelease];
#else
        LeapDevice *device = [[LeapDevice alloc] initWithDevice:(void *)&leapDevice];
#endif
        [devices_ar addObject:device];
    }
    return [NSArray arrayWithArray:devices_ar];
}

- (BOOL)isConnected
{
    return _controller->isConnected();
}

- (BOOL)isServiceConnected
{
  return _controller->isServiceConnected();
}

- (BOOL)hasFocus
{
    return _controller->hasFocus();
}

- (void)enableGesture:(LeapGestureType)gesture_type enable:(BOOL)enable
{
    _controller->enableGesture(Leap::Gesture::Type(gesture_type), enable);
}

- (BOOL)isGestureEnabled:(LeapGestureType)gesture_type
{
    return _controller->isGestureEnabled(Leap::Gesture::Type(gesture_type));
}

- (NSArray *)locatedScreens
{
    Leap::ScreenList leapScreens = _controller->locatedScreens();
    NSMutableArray *screens_ar = [NSMutableArray array];
    for (Leap::ScreenList::const_iterator it = leapScreens.begin(); it != leapScreens.end(); ++it) {
        Leap::Screen leapScreen = *it;
#if !__has_feature(objc_arc)
        LeapScreen *screen = [[[LeapScreen alloc] initWithScreen:(void *)&leapScreen] autorelease];
#else
        LeapScreen *screen = [[LeapScreen alloc] initWithScreen:(void *)&leapScreen];
#endif
        [screens_ar addObject:screen];
    }
    return [NSArray arrayWithArray:screens_ar];
}

- (void)dealloc
{
    if (_listener) {
        if (_controller) {
            _controller->removeListener(*_listener);
        }
        delete _listener;
    }
    if (_controller) {
        delete _controller;
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end;


@implementation NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject
{
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
    [self postNotificationOnMainThread:notification];
}

@end


@implementation NSArray (LeapPointableOrHandList)

- (id)leftmost
{
    if ([self count] == 0) {
        return nil;
    }
    float minX = FLT_MAX;
    NSUInteger minPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        float x = (([obj isKindOfClass:[LeapHand class]] == YES) ?
                   [[obj palmPosition] x] :
                   [[obj tipPosition ] x]);
        if (x < minX) {
            minPosition = i;
            minX = x;
        }
    }
    return [self objectAtIndex:minPosition];
}

- (id)rightmost
{
    if ([self count] == 0) {
        return nil;
    }
    float maxX = -FLT_MAX;
    NSUInteger maxPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        float x = (([obj isKindOfClass:[LeapHand class]] == YES) ?
                   [[obj palmPosition] x] :
                   [[obj tipPosition ] x]);
        if (x > maxX) {
            maxPosition = i;
            maxX = x;
        }
    }
    return [self objectAtIndex:maxPosition];
}

- (id)frontmost
{
    if ([self count] == 0) {
        return nil;
    }
    float minZ = FLT_MAX;
    NSUInteger minPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        float z = (([obj isKindOfClass:[LeapHand class]] == YES) ?
                   [[obj palmPosition] z] :
                   [[obj tipPosition ] z]);
        if (z < minZ) {
            minPosition = i;
            minZ = z;
        }
    }
    return [self objectAtIndex:minPosition];
}

- (NSArray *)extended
{
    NSMutableArray *pointables_ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < [self count]; i++) {
        LeapPointable *pointable = [self objectAtIndex:i];
        if ([pointable isExtended]) {
            [pointables_ar addObject:pointable];
        }
    }
    return [NSArray arrayWithArray:pointables_ar];
}

- (NSArray *)fingerType:(LeapFingerType)type;
{
    NSMutableArray *fingers_ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < [self count]; i++) {
        LeapPointable *pointable = [self objectAtIndex:i];
        if ([pointable isFinger]) {
            LeapFinger *finger = (LeapFinger *)pointable;
            if ([finger type] == type) {
                [fingers_ar addObject:pointable];
            }
        }
    }
    return [NSArray arrayWithArray:fingers_ar];
}

@end


@implementation NSArray (LeapScreenList)
- (LeapScreen *)closestScreenHit:(LeapPointable *)pointable
{
    return [self closestScreenHit:[pointable tipPosition] direction:[pointable direction]];
}
- (LeapScreen *)closestScreenHit:(const LeapVector *)position direction:(const LeapVector *)direction
{
    static const float epsilon = 1e-6f;
    float minDistSq = FLT_MAX;
    float minErrorSq = FLT_MAX;
    int bestIndex = -1;
    NSUInteger num = [self count];
    for (int i=0; i<num; i++) {
        LeapScreen *screen = [self objectAtIndex:i];
        // Perform a ray-cast projection onto each screen in the given direction
        LeapVector *result = [screen intersect:position direction:direction normalize:NO clampRatio:1.0f];
        LeapVector *unclamped = [screen intersect:position direction:direction normalize:NO clampRatio:1000.0f];
        float curErrorSq = [[result minus:unclamped] magnitudeSquared];
        float curDistSq = [[result minus:position] magnitudeSquared];
        // Find the projected screen point closest to the unclamped projection
        // In equality cases, break ties using distance from the original position
        if (curErrorSq < minErrorSq ||
            ((curErrorSq - minErrorSq < epsilon) && curDistSq < minDistSq)) {
            minErrorSq = curErrorSq;
            minDistSq = curDistSq;
            bestIndex = i;
        }
    }
    if (bestIndex >= 0) {
        return [self objectAtIndex:bestIndex];
    }
    return [LeapScreen invalid];
}

- (LeapScreen *)closestScreen:(LeapVector *)position
{
    static const float epsilon = 1e-6f;
    float minDistSq = FLT_MAX;
    float minErrorSq = FLT_MAX;
    int bestIndex = -1;
    NSUInteger num = [self count];
    for (int i=0; i<num; i++) {
        LeapScreen *screen =[self objectAtIndex:i];
        // Perform a perpendicular projection onto each screen
        LeapVector *result = [screen project:position normalize:NO clampRatio:1.0f];
        LeapVector *unclamped = [screen project:position normalize:NO clampRatio:1000.0f];
        float curErrorSq = [[result minus:unclamped] magnitudeSquared];
        float curDistSq = [[result minus:position] magnitudeSquared];
        // Find the projected screen point closest to the unclamped projection
        // In equality cases, break ties using distance from the original position
        if (curErrorSq < minErrorSq ||
            ((curErrorSq - minErrorSq < epsilon) && curDistSq < minDistSq)) {
            minErrorSq = curErrorSq;
            minDistSq = curDistSq;
            bestIndex = i;
        }
    }
    if (bestIndex >= 0) {
        return [self objectAtIndex:bestIndex];
    }
    return [LeapScreen invalid];
}
@end

const float LEAP_PI = Leap::PI;
const float LEAP_DEG_TO_RAD = Leap::DEG_TO_RAD;
const float LEAP_RAD_TO_DEG = Leap::RAD_TO_DEG;
