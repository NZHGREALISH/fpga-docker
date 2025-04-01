#!/bin/bash

set -e  # 遇到错误立即退出

# 检查必要的环境变量
check_env() {
    echo "检查环境变量..."
    
    if [ -z "$INSTALL" ]; then
        echo "错误: INSTALL 环境变量未设置"
        exit 1
    fi
    
    echo "检查 RISC-V 工具链..."
    if [ ! -f "/opt/riscv/bin/riscv32-unknown-elf-gcc" ]; then
        echo "错误: RISC-V GCC 编译器未找到"
        echo "期望路径: /opt/riscv/bin/riscv32-unknown-elf-gcc"
        echo "当前目录内容:"
        ls -la /opt/riscv/bin/
        exit 1
    fi
    
    if [ ! -f "/opt/riscv/bin/riscv32-unknown-elf-objdump" ]; then
        echo "错误: RISC-V objdump 未找到"
        echo "期望路径: /opt/riscv/bin/riscv32-unknown-elf-objdump"
        exit 1
    fi
    
    if [ ! -f "/opt/riscv/bin/riscv32-unknown-elf-nm" ]; then
        echo "错误: RISC-V nm 未找到"
        echo "期望路径: /opt/riscv/bin/riscv32-unknown-elf-nm"
        exit 1
    fi
    
    echo "环境检查通过"
}

# 设置环境变量
export INSTALL=/opt/intelFPGA_lite/23.1std
export PATH="/opt/riscv/bin:${PATH}"

# 检查环境
check_env

# 设置项目目录权限
if [ -d "/project" ]; then
    chmod 777 /project
fi

# 启动交互式shell
exec /bin/bash