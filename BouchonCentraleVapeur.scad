
// Bouchon interne
diamSocle = 28;
hauteurSocle = 2.5;
diamBase = 23.5;
hauteurBase = 10;
largeurEcrou = 21.5 ;
hauteurEcrou = 16;
diamTrou=6;
margeTrou=22;

// Bouchon externe
diamExt = 30;
hauteurExt = 30;
rayonGrip = 5;

// Général
nivDetail = 50;


module bouchonInterne() {
    difference() {
        union() {
            // Socle
            cylinder(r1=diamSocle / 2, r2=(diamBase / 2)+2, h=hauteurSocle, $fn=nivDetail);
            // Base
            translate ([0,0,hauteurSocle]) cylinder(r=diamBase / 2, h=hauteurBase, $fn=nivDetail);
            translate ([0,0,hauteurSocle+hauteurBase])
                cylinder(r1=diamBase / 2, R2=10, h=diamTrou*2, $fn=nivDetail);
            // Ecrou
            translate ([0,0,hauteurSocle+hauteurBase]) {
                cylinder(r=largeurEcrou / 2, h=hauteurEcrou, $fn=6);
            }
    
            // Toit
            translate ([0,0,hauteurSocle+hauteurBase+hauteurEcrou])
                cylinder(r1=largeurEcrou / 2, r2=0, h=diamTrou, $fn=6);
            
            // Trou latéral
            translate ([0,0,4+(diamTrou/2)])
                rotate([0,90,0]) {
                    difference() {
                        cylinder(r=diamTrou/2, h=diamBase+margeTrou, center=true, $fn=20);
                        rotate([0,0,90]) cube([2,diamTrou,diamBase+margeTrou], center=true);
                    }
                }                        
    
            // Trou du haut
            cylinder (r=diamTrou / 2 - 1, hauteurExt + margeTrou, $fn=nivDetail);
        }
        // Grips de maintien internes
        rotate([0,0,30]) {
            for (i=[0:60:360]) {
                rotate([0,0,i])
                    translate([largeurEcrou/2-.5,0,diamBase-6.5]) {
                        sphere(2, $fn=20);
                    }
            }
        }
    }
}

module bouchonExterne() {
    niveauDetail = 150;
    difference() {
            union() {
                cylinder (r1=(diamExt / 2)+2, r2=(diamExt / 2)+1, h=3, $fn=100);
                cylinder (r=diamExt / 2, h=hauteurExt, $fn=niveauDetail);
                translate([0,0,hauteurExt]) sphere(diamExt/2, $fn=niveauDetail);
                grip(5);
            }
            for (i=[1,-1]) {
                translate([0,i*(diamExt / 3 + diamTrou),hauteurExt+(diamExt / 3)+ diamTrou])
                        rotate([0,90,00])
                                scale([1.7,1,1]) cylinder (r=diamExt / 2.5, h=diamExt, center=true,$fn=niveauDetail);
            }
    }
}

module grip(largeurGrip) {
    //translate([0,-(diamExt+largeurGrip)/2,0]) cube([largeurGrip, diamExt+largeurGrip, hauteurExt]);
    nivDetail = 50;
    for (i = [0:180:360]) {
        rotate ([0,0,i]) {
            translate([2,0,5]) translate([-diamExt/2+2,0,0]) {
                difference() {
                    translate ([0,0,5]) cylinder(r=largeurGrip, h=hauteurExt-largeurGrip-10, $fn=nivDetail);
                }
                translate([0,0,hauteurExt-largeurGrip-5]) sphere(largeurGrip, $fn=nivDetail);
                translate([0,0,largeurGrip]) sphere(largeurGrip, $fn=nivDetail);
            }
        }
    }
}

module marquage(message) {
    translate ([0,0,hauteurExt+(diamExt/10)])
        rotate([60,0,0])
            translate([0,0,5]) linear_extrude(2) text(message, size=1.5, halign="center");
}

difference() {
    difference() {
	bouchonExterne();
	translate([0,0,-1]) bouchonInterne();
    }
    union() {
        marquage("Designed in Wolfisheim");
        rotate ([0,0,180]) marquage("Régine's Playstation");
    }
}

//bouchonInterne();
//marquage("Designed in Wolfisheim");
//rotate ([0,0,180]) marquage("Régine's Playstation");
