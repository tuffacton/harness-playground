# Secure Notebooks

A secure Jupyter notebook or JupyterLab environment. Can be used for data science but can also be used just as a simpler utility to help with things like labs.

Helpful links
- https://evodify.com/python-r-bash-jupyter-notebook/

# Navigate to the directory containing the Dockerfile
`cd path/to/secure_data_science/secure_notebook`

# Build the Docker image
`docker build -t secure-notebook .`

# Run the Docker container
`docker run -p 8888:8888 secure-notebook`
