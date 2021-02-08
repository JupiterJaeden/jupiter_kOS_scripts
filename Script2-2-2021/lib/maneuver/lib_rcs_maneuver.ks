//Required libraries: lib/rcs
@lazyglobal off.

// IMPORTANT NOTE:
//By defualt, this script assumes that all RCS thrusters on the ship have the ability (and are configured properly) to thrust forward. If this is NOT the case, you need to have the text "no_forward_rcs" somewhere in the kOS tags of ALL your RCS thrusters that cannot thrust forward. THE SCRIPT WILL NOT WORK CORRECTLY OTHERWISE!!!

//Script assumptions:
//Only stock RCS thrusters are being used.
//Any RCS thruster contributing to forward RCS thrust is not angled in any way and is providing 100% of its thrust in a forward direction.
//There is enough RCS fuel to complete the maneuver. It will likely hang if you run out of fuel and will have to be manually terminated. Later this behavior might be changed.
//All RCS thrusters are set to maximum throttle. It will probably not work correctly otherwise.
//The maneuver is being executed in a vacuum.

//Hard-coded values for the stock RCS thrusters
runoncepath("./lib/rcs/lib_rcs_thrust.ks").

//Release controls and reset ship systems.
local function scriptCleanup {
  set ship:control:fore to 0.
  unlock steering.
  set RCS to rcs_state.
  SAS on.
  return.
}

global function executeRCSManeuver {
  declare parameter node. //The maneuver node to be executed

  //Keep track of the state immediately when the script begins (for resetting later)
  declare local rcs_state to RCS.

  //Get all RCS part modules
  declare local rcs_modules to ship:modulesnamed("ModuleRCSFX").

  //Read data about RCS thrusters
  declare local forward_thrust to 0.

  //Get cumulative thruster power from all forward RCS thrusters, in kilonewtons.
  for i in range (0, rcs_modules:length) {
    //Skip any RCS parts tagged with "no_forward_rcs"
    if rcs_modules[i]:part:tag:contains("no_forward_rcs") {
      print "Skipping part tagged with no_forward_rcs.".
    }
    else {
      set forward_thrust to forward_thrust + getStockRCSThrust(rcs_modules[i]:part).
    }
  }

  //No forward RCS thrust has been detected.
  if forward_thrust = 0 {
    print "Ship has no forward RCS thrust, or it could not be detected by the script. Script terminating.".
    return.
  }

  //Calculate some data about the burn
  declare local initial_acceleration to forward_thrust / ship:mass. //Initial possible acceleration in m/s^2
  declare local burn_duration to node:deltav:mag / initial_acceleration. //Duration of burn in seconds

  //Debug logging
  print "Calculated forward RCS thrust: " + forward_thrust + " kN.".
  print "Initial acceleration: " + initial_acceleration + " m/s^2.".
  print "Minimum burn duration at initial acceleration: " + burn_duration + " seconds.".
  print "Estimated burn duration (with throttling down):" + (burn_duration + 9) + " seconds.".

  //Make sure the estimated burn time ss actually in the future. Give ourselves a 30 second margin as well. Terminate script otherwise.
  if node:eta < (burn_duration/2 + 30) {
    print "There is not enough time to execute the next maneuver. Script terminating.".
    return.
  }

  //If we have passed all the checks so far, we are go to execute the maneuver! Now we just need to configure some stuff correctly and wait.
  //Up to this point, nothing has actually been changed. The script has just been reading data. After this point, any script termination needs to call scriptCleanup() to ensure everything is reset.

  //Configure ship systems correctly. (RCS is not changed here, if RCS is on it will stay on, otherwise it will stay off for now)
  SAS off.

  //Lock steering to a COPY of the delta-V vector. This is because we want this vector to remain constant whereas node:deltav will change during the course of the maneuver. This should prevent the "wobble" common with executing precise maneuvers. However it does assume the ship is able to precisely rotate itself pretty close to the exact burn vector.
  lock steering to node:deltav:vec.

  print "All systems are configured and steering is set. Waiting to execute maneuver! Should begin execution in " + (node:eta - burn_duration/2) + " seconds from this message.".

  //Wait to 10 seconds before burn
  wait until node:eta <= (burn_duration/2 + 10).

  print "10 seconds to burn!".

  //Wait until burn
  wait until node:eta <= (burn_duration / 2).

  print "Beginning burn execution!".

  RCS on.

  declare local near_end_of_burn to false.
  declare local previous_deltav to node:deltav:mag.
  set ship:control:fore to 1.

  //Continue to execute burn until there is less than 0.05 m/s of delta-v remaining.
  until node:deltav:mag < 0.05 {
    declare local deltav_remaining to node:deltav:mag. //Ensure this value remains constant throughout this loop execution

    //Make sure we haven't overshot the maneuver (but give small margin)
    if deltav_remaining > (previous_deltav + 0.05) {
      scriptCleanup().
      print "Accidentally overshot the maneuver! Script terminating.".
      return.
    }

    //Check if there is less than or equal to one second of burning left
    if near_end_of_burn = false and deltav_remaining <= initial_acceleration {
      set near_end_of_burn to true.
      print "Nearing end of burn, throttling RCS down to 0.1".
      set ship:control:fore to 0.1.
    }

    //Update previous_deltav
    set previous_deltav to deltav_remaining.
  }

  scriptCleanup().

  //Remove maneuver node.
  remove node.

  print "Successfully executed maneuver node. Script terminating.".
  return.
}
