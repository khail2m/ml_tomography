import torch
from torch import nn

class SeparableConv2d(nn.Module):
    def __init__(self, in_channels, out_channels, kernels, padding=1, bias=False):
        super(SeparableConv2d, self).__init__()
        self.depthwise = nn.Conv2d(in_channels, in_channels,
                kernel_size=kernels, padding=padding, groups=in_channels, bias=bias)
        self.pointwise = nn.Conv2d(in_channels, out_channels,
                kernel_size=1, bias=bias)

    def forward(self, x):
        out = self.depthwise(x)
        out = self.pointwise(out)
        return out
    
    
def conv_block(in_channels,out_channels,kernels,padding=1,bias=False):
    layers = nn.Sequential(
        nn.BatchNorm2d(in_channels),
        nn.ReLU(inplace=True),
        SeparableConv2d(in_channels,out_channels,kernels,padding=padding,bias=bias),
        nn.BatchNorm2d(out_channels),
        nn.ReLU(inplace=True),
        SeparableConv2d(out_channels,out_channels,kernels,padding=padding,bias=bias)
        )

    return layers


class Tomography_CNN(nn.Module):
    def __init__(self, in_channels=1, out_channels=1):
        super().__init__()

        self.layers = nn.Sequential(
            nn.Conv2d(in_channels,64,(7,7),padding=3),
            conv_block(64,64,(5,5),padding=2),
            nn.MaxPool2d((2,2), padding=(0,0)),
            conv_block(64,128,(5,5),padding=2),
            nn.MaxPool2d((2,2), padding=(0,0)),
            conv_block(128,256,(5,5),padding=2),
            nn.MaxPool2d((2,2), padding=(0,0)),
            conv_block(256,512,(5,5),padding=2),
            nn.MaxPool2d((2,5), padding=(0,0)),
            conv_block(512,1024,(5,5),padding=2),
            nn.Dropout(0.5),
            nn.Upsample(scale_factor=(2,5)),
            nn.ConvTranspose2d(1024, 1024, (3,3), padding=1),
            conv_block(1024,512,(5,5),padding=2),
            nn.Upsample(scale_factor=(2,1)),
            nn.ConvTranspose2d(512, 512, (3,3), padding=1),
            conv_block(512,256,(5,5),padding=2),
            nn.Upsample(scale_factor=(2,2)),
            nn.ConvTranspose2d(256, 256, (3,3), padding=1),
            conv_block(256,128,(5,5),padding=2),
            nn.Upsample(scale_factor=(2,1)),
            nn.ConvTranspose2d(128, 128, (3,3), padding=1),
            conv_block(128,64,(5,5),padding=2),
            nn.Conv2d(64,out_channels,(1,1)),
            nn.Sigmoid()
            )
        
        for m in self.modules():
            if isinstance(m, nn.Conv2d):
                # kaiming He Initialization
                nn.init.kaiming_uniform_(m.weight.detach(), nonlinearity='relu')
    
    def forward(self,x):
        return self.layers(x) * 3.5 + 1.5
    