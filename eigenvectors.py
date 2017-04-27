import pandas as pd
import numpy as np

if __name__ == "__main__":
    original_df = pd.read_csv(
        filepath_or_buffer='covar.txt',
        header=None,
        sep=',')

    covar_matrix = original_df.ix[:, 0:4].values

    eigenvalues, eigenvectors = np.linalg.eig(covar_matrix)

    print('Eigenvectors \n{}'.format(eigenvectors))
    print('\nEigenvalues \n{}'.format(eigenvalues))
