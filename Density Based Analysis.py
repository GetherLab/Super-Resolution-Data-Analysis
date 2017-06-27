
# Import libraries

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import scipy.spatial as spatial
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.mlab import griddata
from matplotlib import cbook
from matplotlib import cm
from matplotlib.colors import LightSource
from matplotlib.widgets import RectangleSelector


#Select the input file
raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
L = {'X':Nx,'Y':Ny}
Locs = pd.DataFrame(data=L)



#2D KDE plot of the ROI
sns.set_style("whitegrid", {'axes.grid' : False})
f, ax = plt.subplots(figsize=(9, 9))
ax.set_aspect("equal")
ax = sns.kdeplot(Locs['X'], Locs['Y'],cmap="Reds", shade=True, shade_lowest=False, bw=(50,50))
f.savefig('KDE2.svg')
plt.show()
plt.close()


#Log Hex Bin of the ROI
f, ax = plt.subplots(figsize=(9, 9))
hb = ax.hexbin(Locs['X'], Locs['Y'], gridsize=50, bins='log', cmap='nipy_spectral')
ax.axis([min(Locs['X']), max(Locs['X']), min(Locs['Y']), max(Locs['Y'])])
ax.set_aspect("equal")
ax.set_title("Hexagon binning")
cb = f.colorbar(hb, ax=ax)
cb.set_label('log10(N)')
plt.savefig('LogHexplot.svg')
plt.close()


#Hex Bin of the ROI
f, ax = plt.subplots(figsize=(9, 9))
hb = ax.hexbin(Locs['X'], Locs['Y'], gridsize=40, cmap='nipy_spectral') #Also good - Jet, nipy_spectral,gist_stern
ax.axis([min(Locs['X']), max(Locs['X']), min(Locs['Y']), max(Locs['Y'])])
ax.set_aspect("equal")
ax.set_title("Hexagon binning")
cb = f.colorbar(hb, ax=ax)
cb.set_label('counts')
plt.savefig('Hexplot.png')
plt.close()


#Contour plot by nearest neighbor
raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
L = {'X':Nx,'Y':Ny}
Locs = pd.DataFrame(data=L)

point_tree = spatial.cKDTree(Locs)

f, ax = plt.subplots(figsize=(9, 9))
def Neighbohr(row):
    return len(point_tree.query_ball_point([Locs['X'][row],Locs['Y'][row]],30))

Locs['Z']=0
for itteration in range (0,len(Locs.index)):
    Locs.set_value(itteration,'Z',Neighbohr(itteration))
    
xi = np.linspace(min(Locs['X']), max(Locs['X']), 1000)
yi = np.linspace(min(Locs['Y']), max(Locs['Y']), 1000)

zi = griddata(Locs['X'], Locs['Y'], Locs['Z'], xi, yi, interp='linear')
CS = ax.contour(xi, yi, zi, 15, linewidths=0.5, colors='k')
CS = ax.contourf(xi, yi, zi, 15,vmax=abs(zi).max(), vmin=-abs(zi).max(),cmap = 'RdGy')
f.colorbar(CS) 
plt.show()
#plt.savefig('Neighbors_grey.png')
plt.close()
    


#3D plot where the z axis is the number of neighbors within 30 nm
raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
L = {'X':Nx,'Y':Ny}
Locs = pd.DataFrame(data=L)

point_tree = spatial.cKDTree(Locs)

f, ax = plt.subplots(figsize=(9, 9))
def Neighbohr(row):
    return len(point_tree.query_ball_point([Locs['X'][row],Locs['Y'][row]],30))

Locs['Z']=0
for itteration in range (0,len(Locs.index)):
    Locs.set_value(itteration,'Z',Neighbohr(itteration))
ax = f.add_subplot(111, projection='3d')
pts = ax.scatter(Locs['X'], Locs['Y'], Locs['Z'], s=50,cmap='nipy_spectral',c=Locs['Z'], marker='o')
f.colorbar(pts, shrink=0.5, aspect=5)
plt.show()
plt.close()


#Surface plot where the z axis is the number of neighbors within 30 nm
raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
L = {'X':Nx,'Y':Ny}
Locs = pd.DataFrame(data=L)

point_tree = spatial.cKDTree(Locs)


def Neighbohr(row):
    return len(point_tree.query_ball_point([Locs['X'][row],Locs['Y'][row]],30))

Locs['Z']=0
for itteration in range (0,len(Locs.index)):
    Locs.set_value(itteration,'Z',Neighbohr(itteration))

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
pts = ax.plot_trisurf(Locs['X'], Locs['Y'], Locs['Z'],cmap='nipy_spectral')
fig.colorbar(pts, shrink=0.5, aspect=5)

plt.show()
plt.close()




#2D plot, color coded by neighbors, allowing one to select a ROI

raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
NNy = -(Ny - max(Ny))
L = {'X':Nx,'Y':NNy}
Locs = pd.DataFrame(data=L)

point_tree = spatial.cKDTree(Locs)


def Neighbohr(row):
    return len(point_tree.query_ball_point([Locs['X'][row],Locs['Y'][row]],30))

Locs['Z']=0
for itteration in range (0,len(Locs.index)):
    Locs.set_value(itteration,'Z',Neighbohr(itteration))

def line_select_callback(eclick, erelease):
    'eclick and erelease are the press and release events'
    x1, y1 = eclick.xdata, eclick.ydata
    x2, y2 = erelease.xdata, erelease.ydata
    print("(%3.2f, %3.2f) --> (%3.2f, %3.2f)" % (x1, y1, x2, y2))
    global xmin,xmax,ymin,ymax
    xmin = x1
    xmax = x2
    ymin = y1
    ymax = y2
def toggle_selector(event):
    print(' Key pressed.')
    if event.key in ['Q', 'q'] and toggle_selector.RS.active:
        print(' RectangleSelector deactivated.')
        toggle_selector.RS.set_active(False)
    if event.key in ['A', 'a'] and not toggle_selector.RS.active:
        print(' RectangleSelector activated.')
        toggle_selector.RS.set_active(True)
fig, current_ax = plt.subplots(figsize=(15, 15))                
#N = 100000                                       
#x = np.linspace(0.0, 10.0, N)                    
pts = current_ax.scatter(Locs['X'], Locs['Y'],c=Locs['Z'],cmap='nipy_spectral',s=15)     #Plotting the 2D data
current_ax.set_aspect("equal")       
cbar = fig.colorbar(pts, shrink=0.5, aspect=5)
cbar.ax.tick_params(labelsize=30)
print("\n      click  -->  release")

# drawtype is 'box' or 'line' or 'none'
toggle_selector.RS = RectangleSelector(current_ax, line_select_callback,
                                       drawtype='box', useblit=True,
                                       button=[1, 3],  # don't use middle button
                                       minspanx=5, minspany=5,
                                       spancoords='pixels',
                                       interactive=True)
plt.connect('key_press_event', toggle_selector)

plt.show()
#plt.savefig("MattNeighbors2D.png")
plt.close()


#Viewing the selected ROI as a 3D surface

raw = pd.read_csv('140220 -- V 007.txt',sep='\t')
Nx = raw['Xc']-min(raw['Xc'])
Ny = raw['Yc']-min(raw['Yc'])
NNy = -(Ny - max(Ny))
L = {'X':Nx,'Y':NNy}
Locs = pd.DataFrame(data=L)

point_tree = spatial.cKDTree(Locs)


def Neighbohr(row):
    return len(point_tree.query_ball_point([Locs['X'][row],Locs['Y'][row]],30))

Locs['Z']=0
for itteration in range (0,len(Locs.index)):
    Locs.set_value(itteration,'Z',Neighbohr(itteration))

fig = plt.figure(facecolor='w', figsize=(11, 11))
ax = fig.add_subplot(111, projection='3d')
DLocs = Locs[(Locs['X']>=xmin) & (Locs['X']<=xmax) & (Locs['Y']>=ymin) & (Locs['Y']<=ymax)]

pts = ax.plot_trisurf(DLocs['X'], DLocs['Y'], DLocs['Z'],cmap='nipy_spectral')
cbar = fig.colorbar(pts, shrink=0.5, aspect=5)
cbar.ax.tick_params(labelsize=30) 
ax.view_init(22,azim=-107)
plt.show()
print (ax.azim)
plt.close()





