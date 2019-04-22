DECLARE PARAMETER DESIRED_RADIUS IS 90000.
DECLARE PARAMETER CLEARANCE_DELAY_IN_SECONDS IS 1.

RUN ONCE lib_launch.
RUN ONCE lib_circularize_orbit.
RUN ONCE lib_exit.

CLEARSCREEN.

LAUNCH(DESIRED_RADIUS, CLEARANCE_DELAY_IN_SECONDS).
CIRCULARIZE_ORBIT().
EXIT().