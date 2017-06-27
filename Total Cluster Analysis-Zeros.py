
# Used to gather the size of detected clusters

#Libraries

import graphlab as gl
import matplotlib.pyplot as plt
import os
import graphlab.aggregate as agg
import numpy as np
from scipy.stats import gaussian_kde
import seaborn as sns
import math


#Functions to take the convex hull of the clusters

#Determines the points that makes up the convex hull of a cluster
def Edges(P):
   points = sorted(set(P))
   def cross(o, a, b):
       return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
   lower = []
   for count in points:
           while len(lower) >= 2 and cross(lower[-2], lower[-1], count) <= 0:
               lower.pop()
           lower.append(count)
   upper = []
   for count in reversed(points):
           while len(upper) >= 2 and cross(upper[-2], upper[-1], count) <= 0:
               upper.pop()
           upper.append(count)
   shape = lower[:-1] + upper[:-1]
   return shape
#Finds the Area from the edges verticies through the shoelace algorithm
def Area(shape):
   Area = 0
   Add = 0
   Sub = 0
   for a in range(len(shape)):
       if a != (len(shape)-1):
           Add = Add + shape[a][0]* shape[a+1][1]
           Sub = Sub + shape[a][1]* shape[a+1][0]
       else:
           Add = Add + shape[a][0]* shape[0][1]
           Sub = Sub + shape[a][1]* shape[0][0]
   Area = (((Add - Sub)**2)**0.5)* 0.5
   return Area

#Main function
def Main(filename):  
   
   #import in the txt file as a SFrame
   Raw_Image = gl.SFrame.read_csv(filename, delimiter = '	',header = True)
    
   #shift points so the min is (0,0)
   Sauce = gl.SFrame({'X': Raw_Image['Xc']-min(Raw_Image['Xc']),'Y': Raw_Image['Yc']-min(Raw_Image['Yc'])})
   
   #Runs DBSCAN on the points
   #Cluster
   Image_C = gl.dbscan.create(Sauce, radius = 30, min_core_neighbors = 20)
   Noise_Filter = gl.dbscan.create(Sauce, radius = 60, min_core_neighbors = 10)
   Sauce = Sauce.add_row_number('row_id')
   
   #Add the cluster identity to each point 
   Image_Points = Sauce.join(Image_C['cluster_id'], on='row_id', how='left')
   Noise_Filter_p = Sauce.join(Noise_Filter['cluster_id'], on='row_id', how='left')  
   
   #Removes non clustered points
   Image_Pts = Image_Points[Image_Points['cluster_id']>=0]
   Noise_Filter_p = Noise_Filter_p[Noise_Filter_p['cluster_id']>=0]
   
   #Determines subject and treatment from filename
   if filename.find('++') > 0:
       #Treat = 'Antagonist'
       #Treat = 'CytD'
       elif filename.find('+-')>0:
       #Treat = 'NMDA'
       #Treat = 'Nicotine'
       #Treat = 'KCl'
       #Treat = 'mbCD'
   else :
       Treat = "Control"
   if filename.find('E')>0:
       Subject= 'Extension'
   elif filename.find('V')>0:
       Subject ='Varicosity' 
   else:
       Subject ='Soma'
       
   #Creates SArray to store cluster volumes in    
   Clus_Vol = gl.SArray(data=[])
       
   #Initialize total clustered area of subject to be 0
   Area_t = 0
   Total_Clusters = Image_Pts.groupby(key_columns='cluster_id',operations={'Num_points':agg.COUNT('row_id')})
   Total_Clusters = Total_Clusters.sort('cluster_id')
   
   #Determines the areas of each cluster and total clustered area of the subject
   Image_Points = Image_Points.sort('cluster_id', ascending = False)
   print Image_Points[0]['cluster_id']
   if Image_Points[0]['cluster_id'] != None:
       #The number of clusters present in the subject
       Num_C = int((Image_Pts.sort('cluster_id', ascending = False))[0]['cluster_id'])
       for c in range(0,Num_C+1):
           cluster_mask = Image_Pts['cluster_id'] == c
           x,y = Image_Pts['X'][cluster_mask],Image_Pts['Y'][cluster_mask]
           P = zip(x,y)
           shape_c = Edges(P)
           Area_c = Area(shape_c)
           Area_t = Area_c + Area_t
           qwe = gl.SArray(data=[Area_c])
           Clus_Vol = Clus_Vol.append(qwe)
       Total_Clusters = Total_Clusters.add_column(Clus_Vol,name ='Cluster Area')
       Total_Clusters = Total_Clusters.add_column(Total_Clusters['Num_points']/Total_Clusters['Cluster Area'],name='Cluster Density')
   else:
       Num_C = -1
       Total_Clusters = gl.SFrame({'cluster_id':[0],'Num_points':[0],
                  'Cluster Area':[0.0],'Cluster Density':[0.0]})

   Total_Clusters['Treatment']=Treat
   Total_Clusters['Subject']=Subject
   Total_Clusters['File']=filename
    
   Image_Data = Total_Clusters.groupby(key_columns='File', operations ={'Mean Cluster Area':agg.MEAN('Cluster Area'),
                                                                        'Mean Num Pts in Clus':agg.MEAN('Num_points'),
                                                                       'Mean Density':agg.MEAN('Cluster Density')})
   Image_Data['Treatment']=Treat
   Image_Data['Subject']=Subject
   Image_Data['Number of Clusters'] = Num_C+1
   Image_Data['Percent Pts clusters'] = float(Image_Pts.num_rows()) / float(Noise_Filter_p.num_rows())*100
   return (Total_Clusters,Image_Data)


#Gathers the data stored in the file "Cluster_Data"

Total_Clusters = gl.SFrame({'cluster_id':gl.SArray(dtype = int),'Num_points':gl.SArray(dtype = int),
                   'Cluster Area':gl.SArray(dtype = float),
                   'Cluster Density':gl.SArray(dtype = float),'Treatment':gl.SArray(dtype = str), 'File':gl.SArray(dtype = str),
                   'Subject':gl.SArray(dtype = str)})
Total_Image =gl.SFrame({'Treatment':gl.SArray(dtype = str), 'File':gl.SArray(dtype = str),
                   'Subject':gl.SArray(dtype = str),'Number of Clusters':gl.SArray(dtype = int),
                       'Percent Pts clusters':gl.SArray(dtype = float),
                       'Mean Cluster Area':gl.SArray(dtype = float),'Mean Density':gl.SArray(dtype = float),
                       'Mean Num Pts in Clus':gl.SArray(dtype = float)})
for f in os.listdir('Cluster_Data'):     #loads up every txt file in the cluster_data dir but sources from main dir
    C,I = Main('Cluster_Data/'+ f)
    Total_Clusters = Total_Clusters.append(C) #makes master list
    Total_Image = Total_Image.append(I)  #makes master list
    Total_Clusters = Total_Clusters.sort(['Subject',"Treatment",'File','cluster_id'])
    Total_Image = Total_Image.sort(['Subject',"Treatment",'File'])
    Total_Clusters.export_csv(filename = 'Total Clusters.txt', delimiter = ' 	')
    Total_Image.export_csv(filename = 'Total Image.txt', delimiter = ' 	')



