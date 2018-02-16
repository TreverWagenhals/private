#include <stdio.h>
#include <string.h>

void removeHeader(FILE *input_file, char file_type[], unsigned *size_X, unsigned *size_Y, unsigned *image_intensity);

int main(int argc, char *argv[])
{
	FILE *input_file;
	FILE *output_file;
	
	unsigned char pixel;
	unsigned x, y;
	unsigned size_X;
	unsigned size_Y;
	unsigned image_intensity;
	unsigned image_size;
	char *file_type;
  
	// open the file to read the input image from
	input_file = fopen(argv[1], "rb");
	// If file failed to open, present error and exit
	if (input_file == NULL)
	{
		puts("invalid input");
		return 1;
	}  
  
	// open the file to write the output image to
	output_file = fopen(argv[2], "wb");
	if (output_file == NULL)
	{
		puts("invalid output");
		return 1;
	} 
  
	// Scans input file until endline character and stores as "file_type"
	fscanf(input_file, "%[^\n]", file_type);
	// Scans next line that contains #rows and #columns. Extra space in scan string
	// makes sure endline character is ignored
	fscanf(input_file, " %u %u ", &size_X, &size_Y);
	// Third line contains image_intensity
	fscanf(input_file, " %u ", &image_intensity);	
	image_size = size_X * size_Y;
	
	// If part1 argument used, produce image to match part1 requirements. Third quadrant
	// will be blacked out
	if (!strcmp(argv[3], "part1"))
	{
		// Print the three header lines to new file in the same format they were in
		fprintf(output_file, "%s \n%d %d\n%d\n", file_type, size_X, size_Y, image_intensity);
		for (y = 0; y < size_Y; y++)
		{
			for (x = 0; x < size_X; x++)
			{
				fread(&pixel, sizeof(char), 1, input_file);
				if ((y <= size_Y / 2) || ((y > size_Y / 2) && (x > size_X / 2)))
					fwrite(&pixel, sizeof(char), 1, output_file); 
				else 
					fputc(0, output_file);
			}
		}
	}
	// Part2, every other row and column is skipped, changing the resolution from size_X * size_Y
	// to (size_X / 2) * (size_Y / 2)
	else if (!strcmp(argv[3], "part2"))
	{
		// Print the three headers lines to new file and edit the #row and #columns to be correct
		fprintf(output_file, "%s \n%d %d\n%d\n", file_type, size_X/2, size_Y/2, image_intensity);
		for (y = 0; y < size_Y; y++)
		{
			for (x = 0; x < size_X; x++)
			{
				// Read in each pixel and then decide whether to present it to the write file
				fread(&pixel, sizeof(char), 1, input_file);
				// Only write odd column and row pixels
				if (y % 2 == 1 && x % 2 == 1)
					fwrite(&pixel, sizeof(char), 1, output_file); 
			}
		}
	}

	fclose(output_file);
	fclose(input_file);
	return 0;
}

void removeHeader(FILE *input_file, char file_type[], unsigned *size_X, unsigned *size_Y, unsigned *image_intensity)
{
	fscanf(input_file,"%[^\n]", file_type);
	fscanf(input_file, " %u %u ", size_X, size_Y);
	fscanf(input_file, " %u ", image_intensity);		
}