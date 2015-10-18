$fn = 32;

E3Dv5_diameter = 25;
E3Dv5_height = 31.8;
radiator_wall = 4;
ziptie_width = 3;
ziptie_height = 2;
fan_hole_diameter = 36;
air_hole_diameter = 27;

include <MCAD/boxes.scad>;


module radiator_holder(d, h, w) {
    side = d+2*radiator_wall;
    radius = w;
    difference() {
        translate([-2*w, 0, 0])
        union() {
            // тело
            roundedBox([side, side, h], radius, true);
            // ушки
            translate([18, 0, 0])
            difference() {
                rotate([90,0,0]) difference() {
                    hull() {
                        roundedBox([5, 3*ziptie_width, side-2*radius], 1, true);
                        translate([-2.5, 3*ziptie_width, 0])
                        cylinder(r=1, h=side-2*radius, center=true);
                    }
                    roundedBox([ziptie_height, 2*ziptie_width, side-2*radius], 1, true);
                }
            }
        }
        // вырезаем сам радиатор
        scale(1.05) cylinder(d=d, h=h, center=true);
        // вырезаем щель между ушками
        #translate([11, 0, 2]) cube([5, 19.8, 15], center=true);
        // дырка для воздуха
        translate([-17/2,0,0]) rotate([0, 90, 0]) cylinder(d=air_hole_diameter, h=17, center=true);
        // отрезаем округлую часть
        translate([-10/2-17, 0, 0]) cube([10, side, E3Dv5_height], center=true);
    }
}


module air_tube(w, h, l) {
    union() {
        difference() {
            cube([l, w, h], center=true);
            rotate([0, 90, 0]) cylinder(d=27, h=l+1, center=true);
        }
        // крепёж на каретку
        cube([l, w, h], center=true);

    }
}


module fan_holder(side, thickness, holes=false) {
    if (holes) {
        difference() {
            cube([thickness, side, side], center=true);
            // дырки под крепёж
            for (i=[0:90:360]) {
                rotate([i, 0, 0])
                rotate([0, 90, 0])
                translate([16, 16, 0])
                cylinder(d=3, h=15, center=true);
            }
            // дырка под воздух
            rotate([0, 90, 0])
            cylinder(d=fan_hole_diameter, h=thickness+1, center=true);

        }
    } else {
        cube([thickness, side, side], center=true);
    }
}


M3_nut = [3, 6.4, 2.7, 4];
M4_nut = [4, 8.1, 3.2, 5];
M6_nut = [6, 11.5,  5, 8];
M8_nut = [8, 15,  6.5, 8];

function nut_radius(type) = type[1] / 2;
function nut_flat_radius(type) = nut_radius(type) * cos(30);
function nut_thickness(type, nyloc = false) = nyloc ? type[3] : type[2];

module nut(type) {
    hole_rad  = type[0] / 2;
    outer_rad = nut_radius(type);
    thickness = nut_thickness(type);
    nyloc_thickness = type[3];

    render() difference() {
        cylinder(r = outer_rad, h = thickness, $fn = 6);
        translate([0,0,-1])
            cylinder(r = hole_rad, h = nyloc_thickness + 2);
    }
}

side = E3Dv5_diameter+2*radiator_wall;

radiator_holder(E3Dv5_diameter, E3Dv5_height, radiator_wall);

difference() {
    hull() {
        translate([-4/2-17, 0, 0]) air_tube(side, E3Dv5_height, 4);
        translate([4/2-17-47, -(40-side)/2, -(40-E3Dv5_height)/2]) fan_holder(40, 4, holes=false);
    }
    hull() {
        translate([-8/2-17, 0, 0]) rotate([0, 90, 0])
        cylinder(d=air_hole_diameter, h=4);
        translate([-17-47, -(40-side)/2, -(40-E3Dv5_height)/2]) rotate([0, 90, 0])
        cylinder(d=fan_hole_diameter, h=4);
    }
    translate([-63,  -(40-side)/2, -(40-E3Dv5_height)/2]) {
        rotate([0, 0, 0]) translate([-0.3, 16, 16]) rotate([0, 90, 0]) rotate([0,0,90])
        scale(1.1) {
            nut(M3_nut);
            translate([0, 0, -2])
            cylinder(d=3, h=10);
        }
        rotate([90, 0, 0]) translate([-0.3, 16, 16]) rotate([0, 90, 0]) rotate([0,0,0])
        scale(1.1) {
            nut(M3_nut);
            translate([0, 0, -2])
            cylinder(d=3, h=10);
        }
        rotate([270, 0, 0]) translate([-0.3, 16, 16]) rotate([0, 90, 0]) rotate([0,0,0])
        scale(1.1) {
            nut(M3_nut);
            translate([0, 0, -2])
            cylinder(d=3, h=10);
        }
        rotate([180, 0, 0]) translate([-0.3, 16, 16]) rotate([0, 90, 0]) rotate([0,0,90])
        scale(1.1) {
            nut(M3_nut);
            translate([0, 0, -2])
            cylinder(d=3, h=10);
        }

        translate([1.2, 19.5, 16]) cube([3, 7, 6.1], center=true);
        translate([1.2, -19.5, 16]) cube([3, 7, 6.1], center=true);
        translate([1.2, 19.5, -16]) cube([3, 7, 6.1], center=true);
        translate([1.2, -19.5, -16]) cube([3, 7, 6.1], center=true);
    }
}

// translate([-4/2-17-47-4, -(40-side)/2, -(40-E3Dv5_height)/2]) {
//     fan_holder(40, 10, holes=true);
// }

translate([-4/2-17-47-16, -(40-side)/2, -(40-E3Dv5_height)/2]) {
    fan_holder(40, 4, holes=true);
    translate([0,0,20]) {
        difference() {
            hull() {
                cube([4, 40, 1], center=true);
                translate([0,(40-side)/2,10])
                rotate([0,90,0])
                cylinder(d=10, h=4, center=true);
            }
            translate([0,(40-side)/2,6])
            cube([4, 3, 12], center=true);
        }
    }
}
