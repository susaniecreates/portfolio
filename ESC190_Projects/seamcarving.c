
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "c_img.h"
#include "seamcarving.h"

// Helper function

int delta_x(struct rgb_img *im, int y, int x)
{
    int rx, gx, bx;
    int right, left;
    right = x + 1;
    left = x - 1;

    if (x == 0)
    {
        rx = get_pixel(im, y, (im->width)-1, 0) - get_pixel(im, y, right, 0);
        gx = get_pixel(im, y, (im->width)-1, 1) - get_pixel(im, y, right, 1);
        bx = get_pixel(im, y, (im->width)-1, 2) - get_pixel(im, y, right, 2);
        return (rx*rx) + (gx*gx) + (bx*bx);
    }

    else if (x == im->width - 1)
    {
        rx = get_pixel(im, y, 0, 0) - get_pixel(im, y, left, 0);
        gx = get_pixel(im, y, 0, 1) - get_pixel(im, y, left, 1);
        bx = get_pixel(im, y, 0, 2) - get_pixel(im, y, left, 2); 
        return (rx*rx) + (gx*gx) + (bx*bx);
     
    }

    else
    {
        rx = get_pixel(im, y, right, 0) - get_pixel(im, y, left, 0);
        gx = get_pixel(im, y, right, 1) - get_pixel(im, y, left, 1);
        bx = get_pixel(im, y, right, 2) - get_pixel(im, y, left, 2); 
        return (rx*rx) + (gx*gx) + (bx*bx);
     
    }

}

int delta_y(struct rgb_img *im, int y, int x)
{
    int ry, gy, by;
    int up, down;
    up = y - 1;
    down = y + 1;


    if (y == 0)
    {
        ry = get_pixel(im, (im->height)-1, x, 0) - get_pixel(im, down, x, 0);
        gy = get_pixel(im, (im->height)-1, x, 1) - get_pixel(im, down, x, 1);
        by = get_pixel(im, (im->height)-1, x, 2) - get_pixel(im, down, x, 2);
        return (ry*ry) + (gy*gy) + (by*by);
    }

    else if (y == im->height - 1)
    {
        ry = get_pixel(im, 0, x, 0) - get_pixel(im, up, x, 0);
        gy = get_pixel(im, 0, x, 1) - get_pixel(im, up, x, 1);
        by = get_pixel(im, 0, x, 2) - get_pixel(im, up, x, 2);
        return (ry*ry) + (gy*gy) + (by*by);
     
    }

    else
    {
        ry = get_pixel(im, down, x, 0) - get_pixel(im, up, x, 0);
        gy = get_pixel(im, down, x, 1) - get_pixel(im, up, x, 1);
        by = get_pixel(im, down, x, 2) - get_pixel(im, up, x, 2); 
        return (ry*ry) + (gy*gy) + (by*by);
     
    }

}
// Compute the dual-gradient energy function, and place it in the struct rgb_img *grad    

void calc_energy(struct rgb_img *im, struct rgb_img **grad){

    int height = im->height;
    int width = im->width;

    create_img(grad, im->height, im->width);

    for (int y = 0; y < (height); y++){
        for (int x = 0; x < (width); x++){
            int delta_x_value = delta_x(im, y, x);
            int delta_y_value = delta_y(im, y, x);
            double energy = sqrt(delta_x_value + delta_y_value) / 10;
            uint8_t set_energy = (uint8_t)energy;
            set_pixel(*grad, y, x, set_energy, set_energy, set_energy);
        }
    }
}

void dynamic_seam(struct rgb_img *grad, double **best_arr){
    int height = grad->height;
    int width = grad->width;

    *best_arr = (double *)malloc(sizeof(double) * height * width);
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            if (y == 0) {
                (*best_arr)[y * width + x] = (double)get_pixel(grad, y, x, 0);
            }
            else {
                double min_energy;
                if (x == 0) // leftmost column
                {
                    min_energy = get_pixel(grad, y, x, 0) + fmin((*best_arr)[(y - 1) * width + x], (*best_arr)[(y - 1) * width + x + 1]);
                }
                else if (x == (width - 1)) // rightmost column
                {
                    min_energy = get_pixel(grad, y, x, 0) + fmin((*best_arr)[(y - 1) * width + x - 1], (*best_arr)[(y - 1) * width + x]);
                }
                else  // in between
                {
                    double min_between = fmin((*best_arr)[(y - 1) * width + x - 1], (*best_arr)[(y - 1) * width + x]);
                    min_energy = get_pixel(grad, y, x, 0) + fmin(min_between, (*best_arr)[(y - 1) * width + x + 1]);
                }
                (*best_arr)[y * width + x] = min_energy;
            }
        }
    }
}

// helper function for recover_path
int min_path(double *best, int y, int x, int height, int width){

    int min_position; // best next path value

    if (x == 0) // leftmost column
    {
        if (best[y*(width) + x] < best[y*(width) + x + 1]){
            min_position = x;
        }
        else{
            min_position = x + 1;
        }
    }
    else if (x == (width - 1)) // rightmost column
    {
        if (best[y*(width) + x - 1] < best[y*(width) + x]){
            min_position = x - 1;
        }
        else{
            min_position = x;
        }
    }
    else  // in between
    {
        if (best[y*(width) + x - 1] < best[y*(width) + x]){
            min_position = x - 1;
            if (best[y*(width) + x + 1] < best[y*(width) + x - 1]){
                min_position = x + 1;
            }
        }
        else{
            min_position = x;
            if (best[(y*(width) + x + 1)] < best[(y*(width) + x - 1)]){
                min_position = x + 1;
            }
        }
    }
    return min_position;
}

void recover_path(double *best, int height, int width, int **path){
    // Allocate a path through the minimum seam as defined by the array best

    *path = (int *)calloc(height, sizeof(int));
    for (int i = 0; i < height; i++){
        (*path)[i] = width - 1;
    }
             
    // find minimum x position for first row
    for (int x = 0; x < width; x++){
        if (best[x] < best[(*path)[0]]){
            (*path)[0] = x;
        }
    }

    // find best path for remaining rows
    
    for (int y = 1; y < height; y++){
        (*path)[y] = min_path(best, y, (*path)[y-1], height, width);
    } 
}

void remove_seam(struct rgb_img *src, struct rgb_img **dest, int *path){
    // Create the destination image, reducing width by 1
    create_img(dest, src->height, src->width - 1);

    // Copy pixels from source to destination, skipping pixels along the seam
    for (int y = 0; y < src->height; y++) {
        int dest_x = 0; 
        for (int x = 0; x < src->width; x++) {
            if (path[y] != x) {
                set_pixel(*dest, y, dest_x, get_pixel(src, y, x, 0), get_pixel(src, y, x, 1), get_pixel(src, y, x, 2));
                dest_x++;
            }
        }
    }
}
