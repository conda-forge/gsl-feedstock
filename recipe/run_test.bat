setlocal EnableDelayedExpansion

cd test

:: Compile example that links gsl
echo "%PREFIX%\Library\include\gsl\gsl_types.h header during test"
type "%PREFIX%\Library\include\gsl\gsl_types.h"

FOR /F "tokens=* USEBACKQ" %%F IN (`pkg-config --cflags gsl`) DO (
  SET CFLAGS=%%F
)
ECHO "CFLAGS: %CFLAGS%"

:: Compile example that links gsl
cl.exe %CFLAGS% gsl.lib regression_test.c
if errorlevel 1 exit 1

:: Run test
.\regression_test.exe
if errorlevel 1 exit 1
