#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>

void codes() {
}

typedef struct {
    size_t size;
    int *data;
} int_vector;

int_vector *create_vector(size_t n) {
    int_vector *p = malloc(sizeof(int_vector));
    if(p) {
        p->data = malloc(n * sizeof(int));
        p->size = n;
    }
    return p;
}

void delete_vector(int_vector *v) {
    if(v) {
        free(v->data);
        free(v);
    }
}

size_t resize_vector(int_vector *v, size_t n) {
    if(v) {
        int *p = realloc(v->data, (n+1) * sizeof(int));
        if(p) {
            v->data = p;
            v->size = n;
        }
        return v->size;
    }
    return 0;
}

int get_vector(int_vector *v, size_t n) {
    if(v && n < v->size) {
        return v->data[n];
    }
    return -1;
}

void set_vector(int_vector *v, size_t n, int x) {
    if(v) {
        if(n >= v->size) {
            resize_vector(v, n);
        }
        v->data[n] = x;
    }
}

int min(int a, int b) {
	return (a<b)?a:b;
}

int max(int a, int b) {
	return (a>b)?a:b;
}

int strcheck(char* a) {
	int n = strlen(a);
	if(a[n-1]=='$') return 1;
	return 0;
}