/*
 * Project Name: Creepy Robot Head - Nasal Bone
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Structure that will mount
 * the jaw, camera, and neck
 * to the middle plate.
 *
 */

/* *** TODO LIST ***
 *
 * fix upper_upper_screw_holes to reflect new mid-deck.
 *
 */

/* ***** Cheats *****

cube([x,y,z]);
translate([x,y,z]);
rotate([x_deg,y_deg,z_deg]);
cylinder(h=x,d=y);

translate([0,0,0])
    rotate([0,0,0])
        function();

vector = [ // aka: A matrix or array.
[0, 0, 0],          // vector[0][0,1,2]
[0, 0, 0],        // vector[1]
[0, 0, 0],      // vector[2]
[0, 0, 0]         // vector[3]
];


 */

// *** INCLUDE/USE LIBRARIES *** //
use <fillets.scad>;
include <nasal_camera_mount.scad>;
include <jaw.scad>;
include <neck.scad>;


// *** VARIABLES *** //
upper_width = 40;

picam_screw_diam = 2;
jaw_screw_diam = 3;

// To match mounting plate on upper jaw.
lower_width = ((jaw_radius - rect_dim[0]) * 2) - print_gap;

bone_height = picam_xy[0];
bone_length = 150; // Full length of middle plate.

lower_offset = ( (lower_width - upper_width) / 2 );

standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

module nasal_bone_block() {

  translate([0,0,0])  // Length is longer for some reason.  Not an issue.
    cube([ bone_length, upper_width, bone_height ]);

  translate([ 0, 0 - lower_offset ,0])
    cube([ bone_length, lower_width, bone_height / 2 ]);

  translate([0,0,bone_height / 2])
    rotate([0,-90,180])
      fillet_linear_i( bone_length, lower_offset, $fn=standard_fn);

  translate([bone_length, upper_width, bone_height / 2])
    rotate([0,-90,0])
      fillet_linear_i( bone_length, lower_offset, $fn=standard_fn);
}



module jaw_mount_screw_holes() {

  screw_diam = jaw_screw_diam;

  hole_gap = 5;

  screw_rec_loc_x = jaw_radius / 2;
  screw_rec_loc_y = upper_width / 2;
  screw_rec_loc_z = 0;

  screw_rec_loc = [[screw_rec_loc_x, screw_rec_loc_y, screw_rec_loc_z],
                [screw_rec_loc_x * 3, screw_rec_loc_y, screw_rec_loc_z]];

  translate(screw_rec_loc[0])
    cylinder( h=screw_length, d=screw_diam );

  translate(screw_rec_loc[1])
    cylinder( h=screw_length, d=screw_diam );

}



module neck_mount_screw_holes() {

  screw_diam = jaw_screw_diam;

  y_axis_radius = ( servo_overhang * 3 ) // 3 time for thicker structure
                  + servo_top[0]
                  + ( servo_top[1] / 2);

  y_axis_depth = servo_dimension[0];

  add_block_length = [ y_axis_radius + ( servo_overhang * 3 ),
                       2 * y_axis_radius,
                       y_axis_depth ];

  mount_screw_loc0 = [ bone_length - (servo_dimension[1] - servo_cavity[2]),
                       ((lower_width / 2) - lower_offset) - (y_axis_radius / 2),
                       0];

  mount_screw_loc1 = [ bone_length - servo_cavity[2],
                       ((lower_width / 2) - lower_offset) - (y_axis_radius / 2),
                       0];

  mount_screw_loc2 = [ bone_length - (servo_dimension[1] - servo_cavity[2]),
                       ((lower_width / 2) - lower_offset) + (y_axis_radius / 2),
                       0];

  mount_screw_loc3 = [ bone_length - servo_cavity[2],
                       ((lower_width / 2) - lower_offset) + (y_axis_radius / 2),
                       0];

  mount_screw_loc = [ mount_screw_loc0,
                      mount_screw_loc1,
                      mount_screw_loc2,
                      mount_screw_loc3 ];

  recess_depth = bone_height;

  for ( i = [ 0 : 3] ) {

    translate(mount_screw_loc[i])
      rotate([0,0,0])
        recessed_screw_cutout(recess_depth,
                              recess_diam,
                              screw_length,
                              screw_diam);
  }

}


// Difficult to gauge proper location until actual assembly.
// Multiple holes to allow for room of the neck joint.
module upper_screw_holes() {

  screw_diam = jaw_screw_diam;

  hole_gap = 10;

  for ( i = [5 : hole_gap : bone_length] ) {
    translate([i, screw_diam * 1.5, bone_height - screw_length])
        cylinder( h=screw_length, d=screw_diam );
  }

  for ( i = [5 : hole_gap : bone_length] ) {
    translate([i, upper_width - ( screw_diam * 1.5), bone_height - screw_length])
        cylinder( h=screw_length, d=screw_diam );
  }

}


// Camera will be upside down to accomidate the ribbon cable.
module cam_screw_holes() {

  // screw_length offset because
  // OpenSCAD didn't want to build completely through.
  translate([screw_length - 1, (upper_width - picam_xy[1]) / 2, 0])
    rotate([0,-90,0])
      picam_screw_holes(screw_length + 1, picam_screw_diam);

}

module nasal_bone() {

  difference() {

    nasal_bone_block();
    jaw_mount_screw_holes();
    upper_screw_holes();
    cam_screw_holes();
    neck_mount_screw_holes();

  }
}

// Build_it function just for testing out each module
// during development.
module build_it() {

  nasal_bone();

}

// *** MAIN ***  //
build_it();
