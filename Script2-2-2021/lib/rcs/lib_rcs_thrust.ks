//Required libraries: none
@lazyglobal off.

//Gets the thrust in kilonewtons provided by any stock RCS thruster part passed to it. Returns 0 if the part is invalid.
//Accurate as of KSP version 1.11.0.3045
global function getStockRCSThrust {
  declare parameter part.

  //Thruster blocks
  if part:title = "RV-105 RCS Thruster Block" {
    return 1.
  }
  else if part:title = "RV-1X Variable Thruster Block" {
    return 0.1.
  }

  //Linear RCS ports
  else if part:title = "Place-Anywhere 7 Linear RCS Port" {
    return 2.
  }
  else if part:title = "Place Anywhere 1 Linear RCS Port" {
    return 0.2.
  }
  else if part:title = "Vernor Engine" {
    return 12.
  }

  print "A part was passed to getStockRCSThrust() that it did not recognize. Returning 0.".
  return 0.
}
