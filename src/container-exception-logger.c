/*
 * Copyright (C) 2018  ABRT team
 * Copyright (C) 2018  RedHat Inc
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>

#define INIT_PROC_STDERR_FD_PATH "/proc/1/fd/2"
#define DEFAULT_TAG "container-exception-logger"

int main(int argc, char *argv[])
{
    const char *program_usage_string =
        "Usage: abrt-container-logger [--no-tag | --tag STRING | --help]"
        "\n"
        "\nThe tool reads from standard input and writes to '"INIT_PROC_STDERR_FD_PATH"'";

    int opt_notag = 0;
    const char * opt_tag = NULL;
    if (argc > 1)
    {
        for (int i = 1; i < argc; ++i)
        {
            if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0)
            {
                fprintf(stderr, "%s\n", program_usage_string);
                return 1;
            }
            else if (strcmp(argv[i], "--no-tag") == 0)
            {
                opt_notag = 1;
            }
            else if (strcmp(argv[i], "--tag") == 0
                     && i + 1 < argc
                     && argv[i + 1][0] != '-')
            {
                opt_tag = argv[++i];
            }
            else
            {
                fprintf(stderr, "%s\n", program_usage_string);
                return 1;
            }
        }
    }

    FILE *f = fopen(INIT_PROC_STDERR_FD_PATH, "w");
    if (f == NULL)
    {
        perror("Failed to open '"INIT_PROC_STDERR_FD_PATH"' as root");

        /* Try to open the 'INIT_PROC_STDERR_FD_PATH' as normal user because of
           https://github.com/minishift/minishift/issues/2058
        */
        if (seteuid(getuid()) == 0)
        {
            f = fopen(INIT_PROC_STDERR_FD_PATH, "w");
            if (f == NULL)
            {
                perror("Failed to open '"INIT_PROC_STDERR_FD_PATH"' as user");
                return 2;
            }
        }
        else
        {
            perror("Failed to setuid");
            return 3;
        }
    }

    setvbuf (f, NULL, _IONBF, 0);

    if (!opt_notag)
        fprintf(f, "%s - ", opt_tag ? opt_tag : DEFAULT_TAG);

    char buffer[BUFSIZ];
    ssize_t bytes_read = 0;

    while (1)
    {
        bytes_read = read(0, buffer, sizeof buffer);
        if (bytes_read <= 0)
            break;

        if (fwrite(buffer, bytes_read, 1, f) != 1)
        {
            perror("Failed to write to '"INIT_PROC_STDERR_FD_PATH"'");
            fclose(f);
            return 4;
        }
    }
    fclose(f);

    return 0;
}
