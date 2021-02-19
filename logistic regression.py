#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 11:17:56 2020

@author: thulas
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#import datset
dataset =pd.read_csv('leads1.csv',delimiter=';')
x=dataset.iloc[:,:-1].values
y=dataset.iloc[:,5].values




#taking care of missing values

from sklearn.preprocessing import Imputer
imputer = Imputer(missing_values ="NaN", strategy= 'mean',axis =0)# Play around with strategy
imputer=imputer.fit(x[:, 3:4])
x[:, 3:4]=imputer.transform(x[:, 3:4])
             
#Encoding catagorical data
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_x=LabelEncoder()
x[:,0]=labelencoder_x.fit_transform(x[:,0])
onehotencoder=OneHotEncoder(categorical_features=[0])
x=onehotencoder.fit_transform(x).toarray()

labelencoder_y =LabelEncoder()
y=labelencoder_y.fit_transform(y)

#Splitting data into training and test test
from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(x,y, test_size=0.3,random_state=0)

#future scaling
from sklearn.preprocessing import StandardScaler
sc_x= StandardScaler()
x_train = sc_x.fit_transform(x_train)
x_test = sc_x.transform(x_test)

#regression
from sklearn.linear_model import LogisticRegression 
classifier = LogisticRegression(random_state = 0) 
classifier.fit(x_train, y_train) 
y_pred = classifier.predict(x_test) 


#Performance measure – Accuracy
from sklearn.metrics import accuracy_score 
print ("Accuracy : ", accuracy_score(x_test, x_train)) 


#perfomance of the model
from matplotlib.colors import ListedColormap 
X_set, y_set = x_test, y_test 
X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1,  
                               stop = X_set[:, 0].max() + 1, step = 0.01), 
                     np.arange(start = X_set[:, 1].min() - 1,  
                               stop = X_set[:, 1].max() + 1, step = 0.01)) 
  
plt.contourf(X1, X2, classifier.predict( 
             np.array([X1.ravel(), X2.ravel()]).T).reshape( 
             X1.shape), alpha = 0.75, cmap = ListedColormap(('red', 'green'))) 
  
plt.xlim(X1.min(), X1.max()) 
plt.ylim(X2.min(), X2.max()) 
  
for i, j in enumerate(np.unique(y_set)): 
    plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1], 
                c = ListedColormap(('red', 'green'))(i), label = j) 
      
plt.title('Classifier (Test set)') 
plt.xlabel('Age') 
plt.ylabel('Salary') 
plt.legend() 
plt.show() 