#include <stdio.h>
#include "address_map.h"

// LED 控制寄存器地址
#define LEDR_BASE 0xFF200000

// 主函数
int main(void) {
    volatile int * LEDR_ptr = (int *)LEDR_BASE;
    
    // 初始化 LED 显示
    *LEDR_ptr = 0;
    
    // 循环显示模式
    while(1) {
        // 从左到右点亮
        for(int i = 0; i < 10; i++) {
            *LEDR_ptr = (1 << i);
            for(int j = 0; j < 1000000; j++); // 简单延时
        }
        
        // 从右到左点亮
        for(int i = 9; i >= 0; i--) {
            *LEDR_ptr = (1 << i);
            for(int j = 0; j < 1000000; j++); // 简单延时
        }
    }
    
    return 0;
} 