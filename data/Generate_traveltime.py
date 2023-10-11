import numpy as np
import torch
from torchwi import Tomo2d

nx=320
ny=50
h=0.1
shotskip=2

shape = (nx,ny)
meter_to_km=0.001

nshot = 200

sxs = (104 + np.arange(nshot))*h
sy = 0.
ry = 0.

rx = np.zeros((nshot,2),dtype=np.int32)

for ishot in range(nshot):
    rx[ishot,0] = 2 + ishot
    rx[ishot,1] = rx[ishot,0] + 100

print("nshot=%d, sy=%s, ry=%s"%(nshot,sy,ry))

rcv_mask = np.zeros((nshot,nx),dtype=bool)

for ishot in range(nshot):
    ir0 = rx[ishot,0]
    ir1 = rx[ishot,1]
    rcv_mask[ishot,ir0:ir1] = True

nvel = 40000

tomo = Tomo2d(nx,ny,h)
freq = 0.05
vmean = 3.0

for ivel in range(nvel):
    print(ivel,nvel)

    # load velocity
    vel = np.load("./ml_vel/vel%05d.npy"%ivel)

    alpha = 2*np.pi/(20*h)*vmean
    omega = 2.*np.pi*freq - alpha * 1.0j

    if ivel == 0:
        print("omega = ",omega)
    
    tomo.factorize(omega, torch.from_numpy(vel))
    ttime = tomo.forward(torch.from_numpy(sxs), sy, ry)

    t = ttime.detach().numpy().astype(np.float32)

    np.save("./ml_time/time%05d.npy"%ivel, t*rcv_mask)
