@lazyglobal off.

runpath("lib_rcs_thrust.ks").

declare local rcs_modules to ship:modulesnamed("ModuleRCSFX").
declare local total_thrust to 0.

declare local vecdraw_list to list().

for i in range(0, rcs_modules:length) {
  declare local part to rcs_modules[i]:part.

  declare local thrust to getStockRCSThrust(part).
  set total_thrust to total_thrust + thrust.

  declare local vd to vecdraw().
  set vd:start to part:position.
  set vd:vec to part:facing:vector * 5.
  set vd:show to true.

  vecdraw_list:add(vd).

  print part.
  print "Thrust of this part: " + thrust + " kN".
  print "Total cumulative thrust: " + total_thrust + " kN".
}

until false {
  print "vecdraw_list length: " + vecdraw_list:length.

  for i in range(0, vecdraw_list:length) {
    set vecdraw_list[i]:show to true.
  }

  wait 5.
}

//Test vessel actual forward thrust: 30.6 kN

//Notes:
//The thrust of the RCS thruster blocks appears to be calculating more or less correctly, although for some reason it tends to have a bunch of decimal places and be slightly less than the actual forward thrust (but close enough)
//The thrust for the big linear RCS port calculates the same as the RCS thruster blocks, but the vernor engine and small linear RCS port do not work correctly. They either report 0 thrust or a really really small number.

//More notes:
//The reason why the vernor engine and small linear RCS ports don't work right is because the way the part "faces" is totally different than the big linear RCS port! The big linear RCS port faces in the same direction as it provides thrust, but the facing of the other two parts is perpendicular to the thrust vector. Why the KSP devs would do this, I don't know. Anyways, I can't be bothered to try and figure this out right now, so I'm just going to shut this down for now.
