import torch
import pandas as pd

file = open('list_pt', 'r')
lines = file.readlines()

for line in lines:
    line = line.strip()
    pt_file = torch.load(line)
    print(f"What are this pt_file's keys? {pt_file.keys()}")

    label = pt_file['label']
    print(f"What is the label? {label}")

    frames = []
    for key in pt_file['representations'].keys():

        representations = pt_file['representations'][key]
        print(f"The shape of representations[{key}] is: {representations.shape}")

        representations_np = representations.numpy() #convert to Numpy array
        flat = representations_np.flatten()

        frame = pd.DataFrame(flat) #convert to a dataframe
        frame.to_csv(f"{label}_representations_{key}_np.csv",index=False,header=False) #save to file
 
        

