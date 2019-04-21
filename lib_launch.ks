DECLARE GLOBAL FUNCTION LAUNCH {
    PRINT "EXEC 'LAUNCH'...".
    DECLARE PARAMETER DESIRED_RADIUS IS 90000.
    PRINT "    DESIRED_RADIUS: " + DESIRED_RADIUS.
    DECLARE PARAMETER CLEARANCE_DELAY_IN_SECONDS IS 1.
    PRINT "    CLEARANCE_DELAY_IN_SECONDS: " + CLEARANCE_DELAY_IN_SECONDS.
    DECLARE PARAMETER MAX_TURN_DEGREES IS 45.
    PRINT "    MAX_TURN_DEGREES: " + MAX_TURN_DEGREES.
    DECLARE PARAMETER MAX_TURN_ALTITUDE IS 10000.
    PRINT "    MAX_TURN_ALTITUDE: " + MAX_TURN_ALTITUDE.

    LOCK STEERING TO SSET.
    SET SSET TO HEADING(90,90). 
    LOCK THROTTLE TO 1.0.
    STAGE.

    //This is a trigger that constantly checks to see if our thrust is zero.
    //If it is, it will attempt to stage and then return to where the script
    //left off. The PRESERVE keyword keeps the trigger active even after it
    //has been triggered.
    WHEN STAGE:READY THEN {
        LIST ENGINES IN elist.
        FOR e IN elist {
            IF e:FLAMEOUT {
                STAGE.
                PRINT "Staging: " + STAGE:NUMBER.
                BREAK.
            }.
        }.
        PRESERVE.
    }.

    //This will be our main control loop for the ascent. It will
    //cycle through continuously until our apoapsis is greater
    //than 100km. Each cycle, it will check each of the IF
    //statements inside and perform them if their conditions
    //are met

    // Wait for clearance of launch pad.
    WAIT CLEARANCE_DELAY_IN_SECONDS.
    UNTIL SHIP:OBT:APOAPSIS > DESIRED_RADIUS {
        LOCAL current_angle IS 90 - ((SHIP:ALTITUDE / MAX_TURN_ALTITUDE) * MAX_TURN_DEGREES).
        IF current_angle < 45 {
            BREAK.
        }.
        SET SSET TO HEADING(90, current_angle).
    }.
    LOCK STEERING TO HEADING(90, 45).
    WAIT UNTIL SHIP:OBT:APOAPSIS > DESIRED_RADIUS.
    PRINT "Desired apoapsis (" + DESIRED_RADIUS +"m) reached, cutting throttle.".
    LOCK THROTTLE TO 0.
    PRINT "END 'LAUNCH'.".
}.
