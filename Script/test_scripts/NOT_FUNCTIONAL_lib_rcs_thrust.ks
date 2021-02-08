@lazyglobal off.

//NOT COMPLETED/FUNCTIONAL

//Gets the forward thrust in kilonewtons provided by any stock RCS thruster part passed to it. Returns 0 if the part is invalid.
function getStockRCSThrust {
  parameter part.

  //This code is mostly stolen from lib_rcs_burn.ks from this github repo: https://github.com/ElWanderer/kOS_scripts
  //(from the repository as of 1/5/2021)
  //I just changed it a bit to include the new 1.11 RCS parts and to make it all lowercase
  //I also changed it to use the part titles instead of part names

  //Thruster blocks
  if part:title = "RV-105 RCS Thruster Block" {
    return 1 - abs(vdot(part:facing:starvector, facing:vector)).
  }
  else if part:title = "RV-1X Variable Thruster Block" {
    return 0.1 - abs(vdot(part:facing:starvector, facing:vector)).
  }

  //Linear RCS ports
  else if part:title = "Place-Anywhere 7 Linear RCS Port" {
    return 2 * max(0, vdot(part:facing:vector, -facing:vector)).
  }
  else if part:title = "Place Anywhere 1 Linear RCS Port" {
    return 0.2 * max(0, vdot(part:facing:vector, -facing:vector)).
  }

  //NOTE: I HAVE NO IDEA IF THIS WORKS RIGHT!!!
  else if part:title = "Vernor Engine" {
    return 12 * max(0, vdot(part:facing:vector, -facing:vector)).
  }

  print "A part was passed to getStockRCSThrust() that it did not recognize. Returning 0.".
  return 0.
}
