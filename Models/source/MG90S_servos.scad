/*
 * Project Name: Creepy Robot Head - MG90S Servos
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Consolidating servo related modules into a library for later re-use.
 * Pre-populated with measurments from MG90S servo.
 *
 */


// *** INCLUDE/USE LIBRARIES *** //
use <shapes.scad>;
use <fillets.scad>;
use <kamikaze_shapes.scad>;

// *** VARIABLES *** //


/* Dimensions for MG90S Servo
    *Most values from datasheet

        ~3.5  ~14.0
        [---][-------------]
            5.0
            ||
~6.0>   |        |
        |  14.5  | 8.0
~2.0  > |------------------|      ---
~3.0 >-------------------------    |
        |                  | ^ 5.0 |
        |                  |       |
~15.0 > | < 21.0           |      26.5 Height
        |                  |       |
~1.0>===|                  |       |
~5.0 >  |__________________|      ---

        |------ 22.5 ------|
    Width

     --------------------------   ---
     |  |                  |  |    |
     |11|   O              |  |    12.0 Depth
     |  |                  |  |    |
     --------------------------   ---

*/

screw_diameter = 0;
screw_head_diameter = 0;

servo_height      = 26.5;
servo_width       = 22.5;
servo_depth       = 12.0;

servo_sub_height  = 21;

servo_overhang    = 5;

// Breakdown of servo width.
// Front to Axis, Axis Diameter, Axis to Rear.
servo_top = [ 3.5, 5.0, 14.0 ];
servo_top_2 = [14.5, 8];
// Breakdown of the servo height.
// Bottom to cable,
// Calbe width,
// Cable to Overhange,
// Overhange width,
// Overhange to Top.
servo_side = [ 5.0, 1.0, 15.0, 3.0, 8.0 ];

print_gap = 2;

servo_dimension = [ servo_height,
                    servo_width,
                    servo_depth ];

servo_cavity = [ servo_dimension[1] + print_gap,   // Width
                 servo_dimension[2] + print_gap, // Depth
                 servo_sub_height + print_gap ];

servo_recess = [ servo_width + (servo_overhang * 2) + print_gap,
                 servo_depth + print_gap,
                 servo_side[4] + servo_side[3]];

standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

// Dummy servo block for comparison during development.
module dummy_servo(servo_dimension) {

  color("lightblue")
    cube(servo_dimension);

}



// Size of the cavity that servos will fit in.
module servo_cutout() {

  cube(servo_cavity);

}

// Size of additional cavity to allow servo to fit in flush...ish.
module servo_recess_cutout() {

  translate([0,0,0])
    rotate([0,0,0])
      cube(servo_recess);

}

module cable_path_cutout( depth, diam, height ) {

  cble_co_diam = diam;
  cble_co_depth = depth;
  cble_co_height = height;

  cylinder( h=cble_co_depth, d=cble_co_diam);

  translate([0 - cble_co_diam, 0 - cble_co_diam / 2, 0])
  cube([ cble_co_height, cble_co_diam, cble_co_depth ]);

}

// Build_it function just for testing out each module
// during development.
module build_it() {

}

// *** MAIN ***  //
build_it();
