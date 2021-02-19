# Read and preprocess images
#nr_of_images = 5000
import os
image_size = 100


faces = []
labels = []
# read infected train_images
path = 'Macintosh HD⁩/Users⁩/thulas⁩/Documents⁩/Workshop_Hands-on/Data/Face_Recognition/15_Classes'
valid_images = [".jpg",".gif",".png"]

for f in os.listdir(path)[:]:
    ext = os.path.splitext(f)[1]
    if ext.lower() not in valid_images:
        continue
    im = imread(os.path.join(path,f)) 
    im = transform.resize(im,(image_size,image_size),mode='constant',anti_aliasing=True)
    faces.append(im)
    #s = re.sub('[0-9]\w+', '', f)
    s = os.path.splitext(f)[0]
    s = ''.join([i for i in s if not i.isdigit()])
    s = s.replace("_", "")
    labels.append(s)