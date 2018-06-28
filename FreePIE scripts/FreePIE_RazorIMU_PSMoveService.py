def update():
   global yaw
   global roll
   global pitch
   
   yaw = math.radians(ahrsImu.yaw)
   roll = math.radians(ahrsImu.roll)
   pitch = math.radians(ahrsImu.pitch)
   
   freeTrack.yaw = roll-croll
   freeTrack.pitch = (yaw-cyaw) * -1
   freeTrack.roll = (pitch-cpitch) * -1
   
   #Multiply by 10 for SteamVR use
   freeTrack.x = (freePieIO[0].x * 10)
   freeTrack.y = (freePieIO[0].y * 10)
   freeTrack.z = (freePieIO[0].z * 10)
   
   #diagnostics.watch(yaw-cyaw)
   #diagnostics.watch(roll-croll)
   #diagnostics.watch(pitch-cpitch)
   
   #diagnostics.watch(freePieIO[0].x)
   #diagnostics.watch(freePieIO[0].y)
   #diagnostics.watch(freePieIO[0].z)
   
if starting:
   cyaw = 0
   croll = 0
   cpitch = 0
   ahrsImu.update += update
   freePieIO[0].update += update

center = keyboard.getPressed(Key.NumberPad5)

if center:
   cyaw = yaw
   croll = roll
   cpitch = pitch