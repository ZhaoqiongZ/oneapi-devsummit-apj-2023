#!/bin/bash

#
# Copyright (c) 2021-2022 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Format Bash prompt
export PS1='$USER@$HOSTNAME:\w\$ '
export PROMPT_DIRTRIM=2

# Setting common pip cache to ensure maximum reuse b/w users
export PIP_CACHE_DIR=/tmp/pip_cache

# Friendly Aliases
alias get_ip="echo $(ip a | grep -v -e "127.0.0.1" -e "inet6" | grep "inet" | awk {'print($2)}' | sed 's/\/.*//')"
alias activate_oneapi="source /opt/intel/oneapi/setvars.sh --force"

# Help Messages
#alias need_help "slurm commands srun squeue sinfo"


# Create IPEX Env CPU
ENV_NAME=ipex_cpu
deactivate
rm -rf $ENV_NAME
python -m venv $ENV_NAME
source $ENV_NAME/bin/activate
pip install --upgrade pip
pip install scikit-image jupyter matplotlib tqdm ipykernel prettytable
pip3 install torch==2.1  --index-url https://download.pytorch.org/whl/cpu
pip3 install intel_extension_for_pytorch==2.1.0
pip install diffusers transformers accelerate scipy safetensors
jupyter kernelspec uninstall $ENV_NAME -y
python -m ipykernel install --user --name=$ENV_NAME
deactivate


# Create IPEX Env GPU
ENV_NAME=ipex_xpu
deactivate
rm -rf $ENV_NAME
python -m venv $ENV_NAME
source $ENV_NAME/bin/activate
pip install --upgrade pip
pip install scikit-image jupyter matplotlib tqdm ipykernel prettytable
python -m pip install torch==2.0.1a0 torchvision==0.15.2a0 intel_extension_for_pytorch==2.0.110+xpu --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/
pip install diffusers transformers accelerate scipy safetensors
jupyter kernelspec uninstall $ENV_NAME -y
python -m ipykernel install --user --name=$ENV_NAME


# #comment-out

# Start Jupyter
activate_oneapi
ip_address=$(get_ip)
jupyter-notebook --no-browser --ip $ip_address
