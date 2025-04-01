# 为Docker环境调整的Makefile
# 基于原始的Windows Makefile修改

# 基本设置
MAIN   := display.c
HDRS   := address_map.h
SRCS   := $(MAIN)

# 工具链设置 - 使用Docker容器中的工具
CC     := riscv32-unknown-elf-gcc
LD     := $(CC)
OD     := riscv32-unknown-elf-objdump
NM     := riscv32-unknown-elf-nm
RM     := rm -f

# 编译和链接标志 - 与原始Makefile保持一致
# 但根据Docker中可用的工具链做了调整
USERCCFLAGS  := -g -O1 -ffunction-sections -fverbose-asm -fno-inline -gdwarf-2
USERLDFLAGS  := -Wl,--defsym=__stack_pointer$$=0x4000000 -Wl,--defsym=JTAG_UART_BASE=0xff201000

ARCHCCFLAGS  := -march=rv32gc -mabi=ilp32d
ARCHLDFLAGS  := -march=rv32gc -mabi=ilp32d
# 最终的编译和链接标志
CCFLAGS := -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS := $(USERLDFLAGS) $(ARCHLDFLAGS) -lm

# 文件
OBJS    := $(patsubst %, %.o, $(SRCS))

# 编译目标
.PHONY: all clean compile symbols objdump

all: compile

compile: $(basename $(MAIN)).elf

$(basename $(MAIN)).elf: $(OBJS)
	@echo "Linking $@"
	$(LD) $(OBJS) $(LDFLAGS) -o $@

%.c.o: %.c $(HDRS)
	@echo "Compiling $<"
	$(CC) $(CCFLAGS) $< -o $@

symbols: $(basename $(MAIN)).elf
	$(NM) -p $<

objdump: $(basename $(MAIN)).elf
	$(OD) -d -S $<

clean:
	@echo "Cleaning..."
	$(RM) $(basename $(MAIN)).elf $(OBJS)

# 检查RISC-V工具链支持的配置
check-toolchain:
	@echo "检查RISC-V工具链配置..."
	@echo "编译器版本:"
	@$(CC) --version
	@echo ""
	@echo "支持的配置:"
	@$(CC) -v