@lazyglobal off.

set kuniverse:timewarp:warp to 4.

wait until nextnode:eta < 100.

set kuniverse:timewarp:warp to 3.

wait until nextnode:eta < 50.

set kuniverse:timewarp:warp to 2.

wait until nextnode:eta < 10.

set kuniverse:timewarp:warp to 0..

wait until nextnode:eta < 1.

until nextnode:eta < -1 {
  print ship:latitude.
  wait 0.
}
