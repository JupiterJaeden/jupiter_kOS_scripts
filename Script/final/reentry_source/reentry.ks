@lazyglobal off.

declare parameter reentry_type. //can be "srfprograde" or "srfretrograde" depending on which re-entry profile you want.

declare local function main {
  print "Hit ctrl+c at any point to stop. The program will also automatically stop below 10,000m above sea level.".

  SAS off.

  if reentry_type = "srfprograde" {
    lock steering to ship:srfprograde.
  }
  else if reentry_type = "srfretrograde" {
    lock steering to ship:srfretrograde.
  }
  else {
    print "Invalid parameter passed to reentry.ks. Aborting script.".
    return.
  }

  wait until ship:altitude < 10000.
  print "Ship altitude has fallen below 10000m, returning control to pilot.".
  unlock steering.
  return.
}

main().
