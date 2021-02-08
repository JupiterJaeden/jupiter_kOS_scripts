//Required libraries: none
@lazyglobal off.

//Gets the ETA to the ascending node of the input orbit.
global function getETAToAN {
  declare parameter arg_orbit. //The orbit to be analyzed

  declare local eta_to_an to arg_orbit:eta:periapsis - ((arg_orbit:argumentofperiapsis / 360 ) * arg_orbit:period).

  if eta_to_an <= 0 {
    set eta_to_an to eta_to_an + arg_orbit:period.
  }

  return eta_to_an.
}

//Gets the ETA to the "midpoint" (the point halfway between the ascending node and descending node, in the direction of travel) of the input orbit.
global function getETAToMidpoint {
  declare parameter arg_orbit. //The orbit to be analyzed

  declare local eta_to_an getETAToAN(arg_orbit).

  declare local eta_to_midpoint to eta_to_an + arg_orbit:period.

  until (eta_to_midpoint <= arg_orbit:period) {
    set eta_to_midpoint to eta_to_midpoint - arg_orbit:period.
  }

  return eta_to_midpoint.
}
