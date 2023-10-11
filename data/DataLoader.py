import numpy as np
import torch
#import pytorch_lightning as pl

class Dataset(torch.utils.data.Dataset):
    def __init__(self, ivels, nshot, nx, ny):
        super().__init__()
        self.indices = ivels
        self.nshot = nshot
        self.nx = nx
        self.ny = ny

    def __len__(self):
        return len(self.indices)
    
    def __getitem__(self, idx):
        ivel = self.indices[idx]
        return self._load_time(ivel), self._load_vel(ivel)

    def _load_vel(self, ivel):
        #v = np.fromfile("./velocity/vel.%05d.bin"%ivel,dtype=np.float32)
        v = np.load("./ml_vel/vel%05d.npy"%ivel)
        v.shape = (1,self.nx,self.ny) # 1 for channel
        return torch.from_numpy(v)
    
    def _load_time(self, ivel):
        #t = np.fromfile("./time/time.%05d.bin"%ivel,dtype=np.float32)
        t = np.load("./ml_time/time%05d.npy"%ivel)
        t.shape = (1,self.nshot,self.nx)
        return torch.from_numpy(np.transpose(t, axes=(0,2,1)))