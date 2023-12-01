#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

char* nextNBytes(char* input, int start, int n) {
	char* returnValue = malloc(n + 1);
	for (int i = 0; i < n; i++) {
		returnValue[i] = input[start + i];
	}
	returnValue[n] = '\0';
	return returnValue;
}

int main() {
	FILE* f = fopen("input.txt", "r");
	fseek(f, 0, SEEK_END);
	long fsize = ftell(f);
	fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

	char *string = malloc(fsize + 1 + 20);
	fread(string, fsize, 1, f);
	fclose(f);

	uint64_t sum = 0;
	uint8_t numBuffer[2] = {0, 0};
	uint8_t buffLength = 0;
	for (int i = 0; i < fsize; i++) {
		if (isdigit(string[i])) {
			numBuffer[buffLength] = (string[i] - 48);
			buffLength = 1;
			numBuffer[buffLength] = (string[i] - 48);
		}
		switch (string[i]) {
			case '\n': {
				uint8_t tempSum = (numBuffer[0] * 10) + numBuffer[1];
				printf("%zu + %d = %zu\n", sum, tempSum, sum + tempSum);
				sum += tempSum;
				buffLength = 0;
				numBuffer[0] = 0;
				numBuffer[1] = 0;
				break;
			}
			case 'o':
				if (strcmp(nextNBytes(string, i, 3), "one") == 0) {
					numBuffer[buffLength] = 1;
					buffLength = 1;
					numBuffer[buffLength] = 1;
					i += 2;
				}
				break;
			case 't':
				if (strcmp(nextNBytes(string, i, 3), "two") == 0) {
					numBuffer[buffLength] = 2;
					buffLength = 1;
					numBuffer[buffLength] = 2;
					i += 2;
				} else if (strcmp(nextNBytes(string, i, 5), "three") == 0) {
					numBuffer[buffLength] = 3;
					buffLength = 1;
					numBuffer[buffLength] = 3;
					i += 4;
				}
				break;
			case 'f':
				if (strcmp(nextNBytes(string, i, 4), "four") == 0) {
					numBuffer[buffLength] = 4;
					buffLength = 1;
					numBuffer[buffLength] = 4;
					i += 3;
				} else if (strcmp(nextNBytes(string, i, 4), "five") == 0) {
					numBuffer[buffLength] = 5;
					buffLength = 1;
					numBuffer[buffLength] = 5;
					i += 3;
				}
				break;
			case 's':
				if (strcmp(nextNBytes(string, i, 3), "six") == 0) {
					numBuffer[buffLength] = 6;
					buffLength = 1;
					numBuffer[buffLength] = 6;
					i += 2;
				} else if (strcmp(nextNBytes(string, i, 5), "seven") == 0) {
					numBuffer[buffLength] = 7;
					buffLength = 1;
					numBuffer[buffLength] = 7;
					i += 4;
				}
				break;
			case 'e':
				if (strcmp(nextNBytes(string, i, 5), "eight") == 0) {
					numBuffer[buffLength] = 8;
					buffLength = 1;
					numBuffer[buffLength] = 8;
					i += 4;
				}
				break;
			case 'n':
				if (strcmp(nextNBytes(string, i, 4), "nine") == 0) {
					numBuffer[buffLength] = 9;
					buffLength = 1;
					numBuffer[buffLength] = 9;
					i += 3;
				}
				break;
		}
	}
	printf("Part 2: %zu\n", sum);
	return 0;
}
