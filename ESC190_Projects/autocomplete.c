#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "autocomplete.h"


//Part 1


int compare_terms(const void *a, const void *b) { // The terms should be sorted in non-descending lexicographic order
    return strcmp(((term *)a)->term, ((term *)b)->term);
}

void read_in_terms(struct term **terms, int *pnterms, char *filename)
{

    FILE *file = fopen(filename, "r");
    fscanf(file, "%d", pnterms);

    *terms = (term*)malloc((*pnterms) * sizeof(term)); // The function allocates memory for all the terms in the file and stores a pointer to the block in*terms. 
    term *temp_p = *terms;

    int count; 
    for (count = 0; count < *pnterms; count++)
    {
        fscanf(file, "%lf", &((*terms)->weight));
        char buffer[200];
        fgets(buffer, sizeof(buffer), file);
        buffer[strlen(buffer)-1] = 0;
        strcpy((*terms)->term, buffer+1);
        (*terms)++;
    } //  The function reads in all the terms from filename, and places them in the block pointed to by *terms.
    fclose(file);

    // sort in alphabetical order
    qsort(temp_p, *pnterms, sizeof(struct term), compare_terms);
    *terms = temp_p;

}

//Part 2
int lowest_match(term *terms, int nterms, char *substr) {
    int low = 0;
    int high = nterms - 1;
    int mid;
    int result = -1;

    if (nterms == 0) {
        return -1;
    }

    while (low <= high) 
    {
        mid = low + (high - low) / 2;
        if (strncmp(terms[mid].term, substr, strlen(substr)) >= 0) 
        {
            result = mid;
            high = mid - 1;
        } 
        else 
        {
            low = mid + 1;
        }
    }
    return result;
}


//Since the array of (nterms = some number n) terms is sorted in alphabetical order and needs to run in Olog(nterms)--> Binary Search!

//Part 3

int highest_match(term *terms, int nterms, char *substr)
{
    int low = 0;
    int high = nterms - 1;
    int mid;
    int result = -1;

    if (nterms == 0)
    {
        return -1;
    }


    while (low <= high) 
    {
        mid = low + (high - low) / 2;
        if (strncmp(terms[mid].term, substr, strlen(substr)) <= 0) 
        {
            result = mid;
            low = mid + 1;
        } 
        else 
        {
            high = mid - 1;
        }
    }
    return result;
}

//Part 4

int comparing_weight(const void *a, const void *b) {
    const term *x = (const term *)a;
    const term *y = (const term *)b;
    return y->weight - x->weight;
}

void autocomplete(struct term **answer, int *n_answer, struct term *terms, int nterms, char *substr)
{
    int higher_match = highest_match(terms, nterms, substr);
    int lower_match = lowest_match(terms, nterms, substr);

    if (higher_match < 0 || lower_match < 0)
    {
        *n_answer = 0;
        return;
    }

    *n_answer = (higher_match - lower_match) + 1;
    
    //Using bubble sort
    for (int i = lower_match; i < lower_match + *n_answer - 1; i++)
    {
        for (int j = i + 1; j < lower_match + *n_answer; j++)
        {
            if (comparing_weight(&terms[i], &terms[j]) > 0)
            {
                struct term temp = terms[i];
                terms[i] = terms[j];
                terms[j] = temp;
            }
        }
    }

    *answer = (struct term*)malloc(sizeof(struct term) * (*n_answer));
    for (int i = lower_match; i < lower_match + *n_answer; i++)
    {
        strcpy((*answer + i - lower_match)->term, terms[i].term);
        (*answer + i - lower_match)->weight = terms[i].weight;
    }
}
