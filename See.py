# -*- coding: utf-8 -*-
"""
Created on Tue Mar  6 12:57:14 2018

@author: jdr248
"""

import os

import pandas as pd
import numpy as np
from sklearn.cluster import DBSCAN
from scipy.spatial import ConvexHull




def getFile(name):
    cyp = pd.read_csv('Cypher DATV.csv')
    name = name['ROI']
    
    ID=name.split('_')[0]
    ID = int(ID)
    return (cyp.iloc[ID])


    
def Treatment(name):
    name = name['File Names']

    if 'NacBac' in name:
        return 'NacBac'
    elif 'Control' in name:
        return 'Control'
    elif 'Kir' in name:
        return 'Kir'
    elif 'NacMut' in name:
        return 'NacMut'
    elif 'NacMUT' in name:
        return 'NacMut'






def ClusterDB(file,rad,np):
    ID2 = file['File Names']
    ROIname = ID2[:-4]+'.csv'  
    print(ROIname)
    file = file['Blind_File']
    file2 = file
    file = 'Blind_M\\ROIS\\' + file
    Data = pd.read_csv(file)
    
    L = {'X':Data['dX'],'Y':Data['dY']}
    Locs = pd.DataFrame(data=L)


    db = DBSCAN(eps=rad, min_samples = np).fit(Locs[['X','Y']])

    labels = db.labels_
    Data['Cluster']= labels
#    Data.to_csv(ROIname[:-4]+'_'+file2)
    Clustered_Data = Data.loc[Data['Cluster']>-1]
    C = len(Clustered_Data)/len(Data)
    N = len(Data)
    S = Size(Data)
    D = N/S
    print(C)
    return C,N,D,S

def Size(df):
    if len(df)<5:
        return 0
    else:
        hull = ConvexHull(df[['dX','dY']])
        return hull.volume
    
def Size2(Data):
    hull = ConvexHull(Data[['X','Y']])
    return hull.volume

def cluster_Size(file):
    file = file['Blind_File']
    print(file)
    file = 'Blind_M\\ROIS\\' + file
    Data = pd.read_csv(file)
    L = {'X':Data['dX'],'Y':Data['dY']}
    Locs = pd.DataFrame(data=L)
    db = DBSCAN(eps=15, min_samples = 3).fit(Locs[['X','Y']])
    
    labels = db.labels_
    cores = db.core_sample_indices_
    Locs['Cluster']= labels
    
    Locs_clus = Locs.iloc[cores,:] #Only grab the core points
    Counts = Locs_clus["Cluster"].value_counts()
    Locs_clus["Counts"] = [Counts[i] for i in Locs_clus['Cluster']]
    Locs_clus = Locs_clus[Locs_clus["Counts"] > 2]
    
    
    
    Areas = Locs_clus.groupby(['Cluster']).apply(Size2)
    Areas2 = [2*np.sqrt(x/3.14) for x in Areas]
    Locs_clus["Areas"] = [Areas[i] for i in Locs_clus['Cluster']]
    #Change to diameter
    Locs_clus["Areas"] = [2*np.sqrt(x/3.14) for x in Locs_clus["Areas"]]
    Clus_Per = sum(Locs_clus["Areas"] > 75)/ len(Locs_clus )
    CP2 = len([i for i in Areas2 if i >= 75])/len(Areas2)
    return CP2,Clus_Per,len(Locs_clus )


    

Filez = os.listdir('Blind_M\\ROIS\\')

data = {'ROI': Filez}
df = pd.DataFrame(data=data)

xxx = df.apply(getFile,1)
xxx['Blind_File']=df['ROI']
#
xxx['Treatment'] = xxx.apply(Treatment,1)

xxx['Clus_Per'] = xxx.apply(cluster_Size,axis = 1)
xxx[['ByClusters','ByLocs','NumPts']] = xxx['Clus_Per'].apply(pd.Series)


xxx['PC3011'] = xxx.apply(ClusterDB,axis = 1, args = [50,80])
xxx[['PC5080','NumPts','Density','Size']] = xxx['PC3011'].apply(pd.Series)




xxx.to_csv('ClusteredData.csv')








