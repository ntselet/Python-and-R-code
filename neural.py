#%matplotlib inline
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.preprocessing import StandardScaler

# Import Keras libraries
import keras
from keras.models import Sequential
from keras.layers import Activation
from keras.optimizers import SGD
from keras.layers import Dense, Dropout,BatchNormalization
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K
from keras.utils import np_utils
from keras.utils.np_utils import to_categorical

# Data generation (4 classes)

from sklearn.datasets.samples_generator import make_blobs
X, y = make_blobs(n_samples=1000, centers=4, center_box = [-10,10],
random_state=0, cluster_std=1)
plt.scatter(X[:, 0], X[:, 1], s=10,c=y);