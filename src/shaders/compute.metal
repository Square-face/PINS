//
//  compute.metal
//  PINS
//
//  Created by Linus Michelsson on 2023-11-29.
//

#include <metal_stdlib>
using namespace metal;

kernel void check_individual (
  constant uint *nums     [[ buffer(0) ]],
  device   char *results  [[ buffer(1) ]],
          uint3 index         [[ thread_position_in_grid ]]
) {
    results[index.x] = nums[index.x];
}

kernel void check_pin(
      constant  unsigned short *constants [[ buffer(0) ]],
      device    char *resultArray         [[ buffer(1) ]],
                uint3 index               [[ thread_position_in_grid ]]
  ) {
    int pin[10];
    int year = constants[0] + index.x;
    int month = constants[1] + index.y;
    int day = constants[2] + index.z;
    
    int checksum = constants[3];
    
    pin[0] = year / 10;
    pin[1] = year % 10;
    
    pin[2] = month / 10;
    pin[3] = month % 10;
    
    pin[4] = day / 10;
    pin[5] = day % 10;
    
    pin[6] = checksum / 1000;
    pin[7] = (checksum / 100) % 10;
    pin[8] = (checksum / 10) % 10;
    pin[9] = checksum % 10;
    
    int sum = 0;
    
    for (int i = 0; i < 10; i++) {
        sum += pin[i] + ((i & 0b1) ^ 0b1) * (pin[i] + ((pin[i] >= 5) * (-9)));
    }
    
    resultArray[index.x + constants[4] * index.y + constants[4] * constants[5] * index.z] = (sum % 10) == 0;
}

[[kernel]]
void dot_product(
  constant unsigned short *offsets [[buffer(0)]],
  device unsigned short *result [[buffer(1)]],
  uint index [[thread_position_in_grid]])
{
  result[index] = index + offsets[0];
}