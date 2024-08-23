FROM cgr.dev/chainguard/python:latest-dev as builder

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install JupyterLab
RUN pip install jupyterlab

# Install IPython kernel
RUN pip install ipykernel

# Install Bash kernel
RUN pip install bash_kernel

# Use the Chainguard Python FIPS image
FROM cgr.dev/chainguard/python:latest

# Expose the JupyterLab port
EXPOSE 8888

# Set a predefined password for JupyterLab
# RUN jupyter notebook --generate-config && \
#     python3 -c "from notebook.auth import passwd; print(passwd('your_password'))" > hashed_password.txt && \
#     echo "c.NotebookApp.password = u'$(cat hashed_password.txt)'" >> /root/.jupyter/jupyter_notebook_config.py && \
#     rm hashed_password.txt

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]