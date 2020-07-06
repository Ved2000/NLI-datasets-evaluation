# Preprocessing-SNLI-MNLI-Hans-for-sentence-embeddings
Evaluation of Natural language Inference datasets on State of the art models and their combinations and ensembles. Most of the times models work good only on some datasets but t
to be appplicable in real life it needs to be give a decent performance on others too. This repository is dedicted on training the models on one datasets and testing on others.
# Data 
For downloading and obtaining formatted SNLI and MultiNLI datasets run the following:*
```python
chmod u+r+x get_transfer_data.bash
./get_transfer_data.bash
```
Hans.txt is HANS dataset in Json format it simply convert it to a python dataframe and use it accordingly:*
```python
import pandas as pd
read_file = pd.read_csv('path_to_hans.txt',delimiter='\t')
```
# Allen NLP model
Allen NLP model is trained on 
