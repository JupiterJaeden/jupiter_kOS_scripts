@lazyglobal off.

runoncepath("./lib/maneuver/lib_rcs_maneuver.ks").

local function main {
  //Check if ship has any maneuver nodes
  if hasnode = false {
    print "Ship does not have any maneuver nodes. Script terminating.".
    return.
  }

  executeRCSManeuver(nextnode). 
}

main().
