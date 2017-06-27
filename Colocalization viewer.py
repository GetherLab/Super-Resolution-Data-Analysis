

import graphlab as gl
import matplotlib.pyplot as plt



plt.close()
Raw_Data_488 = gl.SFrame.read_csv('C:\Users\Matt\origin_cbc_roi5.txt', delimiter = '\t',header = True)
Raw_Data_647 = gl.SFrame.read_csv('C:\Users\Matt\partner_cbc_roi5.txt', delimiter = '\t',header = True)

Locs_488 = gl.SFrame({'X': Raw_Data_488['# x[nm]'],'Y': Raw_Data_488['y[nm]'],'cbc':Raw_Data_488['cbc[a.u.]']})
Locs_647 = gl.SFrame({'X': Raw_Data_647['# x[nm]'],'Y': Raw_Data_647['y[nm]'],'cbc':Raw_Data_647['cbc[a.u.]']})


#Group all the data by its colocalization value

Locs_488_HiCo=Locs_488[Locs_488['cbc']>=0.55]

Locs_488_LowCo=Locs_488[Locs_488['cbc']>=0.15]
Locs_488_LowCo=Locs_488_LowCo[Locs_488_LowCo['cbc']<0.55]

Locs_488_Mid=Locs_488[Locs_488['cbc']>=-0.15]
Locs_488_Mid=Locs_488_Mid[Locs_488_Mid['cbc']<0.15]

Locs_488_LowNo=Locs_488[Locs_488['cbc']>=-0.55]
Locs_488_LowNo=Locs_488_LowNo[Locs_488_LowNo['cbc']<-0.15]

Locs_488_HiNo=Locs_488[Locs_488['cbc']<-0.55]

Locs_647_HiCo=Locs_647[Locs_647['cbc']>=0.55]

Locs_647_LowCo=Locs_647[Locs_647['cbc']>=0.15]
Locs_647_LowCo=Locs_647_LowCo[Locs_647_LowCo['cbc']<0.55]

Locs_647_Mid=Locs_647[Locs_647['cbc']>=-0.15]
Locs_647_Mid=Locs_647_Mid[Locs_647_Mid['cbc']<0.15]

Locs_647_LowNo=Locs_647[Locs_647['cbc']>=-0.55]
Locs_647_LowNo=Locs_647_LowNo[Locs_647_LowNo['cbc']<-0.15]

Locs_647_HiNo=Locs_647[Locs_647['cbc']<-0.55]




plt.plot(Locs_488_HiNo['X'],Locs_488_HiNo['Y'], 'o',color='#0905FF',alpha=1)
plt.plot(Locs_488_LowNo['X'],Locs_488_LowNo['Y'], 'o',color='#0A76FF',alpha=1)
plt.plot(Locs_488_Mid['X'],Locs_488_Mid['Y'], 'o',color='#19FF59',alpha=0.5)
plt.plot(Locs_488_LowCo['X'],Locs_488_LowCo['Y'], 'o',color='#FFA023',alpha=1)
plt.plot(Locs_488_HiCo['X'],Locs_488_HiCo['Y'], 'o',color='#FFFF28',alpha=1)


plt.axis('equal')
plt.show()



plt.plot(Locs_647_HiNo['X'],Locs_647_HiNo['Y'], 'o',color='#0905FF',alpha=1)
plt.plot(Locs_647_LowNo['X'],Locs_647_LowNo['Y'], 'o',color='#0A76FF',alpha=1)
plt.plot(Locs_647_Mid['X'],Locs_647_Mid['Y'], 'o',color='#19FF59',alpha=0.5)
plt.plot(Locs_647_LowCo['X'],Locs_647_LowCo['Y'], 'o',color='#FFA023',alpha=1)
plt.plot(Locs_647_HiCo['X'],Locs_647_HiCo['Y'], 'o',color='#FFFF28',alpha=1)
plt.axis('equal')
plt.show()

