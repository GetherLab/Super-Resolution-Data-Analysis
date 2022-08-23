# -*- coding: utf-8 -*-
"""
Created on Mon Mar  5 10:37:11 2018

@author: jdr248
"""

import os
import random
import pandas as pd
import numpy as np

Filez = os.listdir('M')
random.shuffle(Filez)
Blind_ID = np.arange(len(Filez))
data = {'File Names': Filez, 'Blind_ID': Blind_ID}
df = pd.DataFrame(data=data)
print (df)
print (range(0,df['File Names'].count()))

for step in range(0,df['File Names'].count()):
    os.rename('M/' + str(df.at[step,'File Names']), 'Blind_M/' + str(df.at[step,'Blind_ID']) + '.csv')
    
df.to_csv('Cypher DATV.csv', index = False)

#%%