# -*- coding: utf-8 -*-
"""
Created on Tue Sep  4 15:25:45 2018

@author: jdr248
"""

import pandas as pd
from sklearn.cluster import DBSCAN
import numpy as np
import matlab.engine
import os

def merg(Data):
    dist = 15
    frame = 5
    
    L = {'X':Data['x [nm]'],'Y':Data['y [nm]'],'F':(Data['frame'])*dist/frame}
    Locs = pd.DataFrame(data=L) #make a dataframe
    db = DBSCAN(eps=dist, min_samples = 1).fit(Locs[['X','Y','F']])      #DBSCAN
    core_samples_mask = np.zeros_like(db.labels_, dtype=bool)           #finds the clustered pts
    core_samples_mask[db.core_sample_indices_] = True                   #identifys clusters
    labels = db.labels_
    Data['Cluster']= labels 
    merged = Data.groupby('Cluster').mean()
    return  merged


for f in os.listdir('output\\'):

    f1 = 'output\\' + f
    print(f1)
    A647 = pd.read_csv(f1,delimiter = ',')
    #'x [nm]','y [nm]','frame'
    PointsA = A647.values[:,(2,3,1)]
    PointsA[:,(0,1)] = PointsA[:,(0,1)]/160
    A = matlab.double(PointsA.tolist())
    
    eng = matlab.engine.start_matlab()
    
    [cors,fd,As,Bs] = eng.RCC(A,2000,256.0,160.0,15.0,20,nargout=4)
      
    drift = np.array(fd._data.tolist())
    DP = np.reshape(drift,(-1,2),order ='F')
   
    corectedPts = np.array(cors._data.tolist())
    CP = np.reshape(corectedPts,(-1,3),order ='F')
    red = pd.DataFrame(data=CP,columns=['X', 'Y','f'])
    
    
    A647['dX'] = red['X']*160
    A647['dY'] = red['Y']*160

    
    uRed = A647.loc[A647['uncertainty [nm]'] <= 25]
    
    mRed = merg(uRed)

    
    saveU = 'U\\'
    saveM = 'M\\'
    
    u1 = saveU + f
    
    m1 = saveM + f
    
    
    uRed.to_csv(u1)

    mRed.to_csv(m1)
#%%
