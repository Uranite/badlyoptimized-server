@echo off

set "DEFAULT_VERSION=26.1.2"

if "%1" == "" call :update %DEFAULT_VERSION% & goto :EOF
if /i "%1" == "update-packwiz" call :update-packwiz & goto :EOF
if /i "%1" == "export" call :export %DEFAULT_VERSION% & goto :EOF
if /i "%1" == "update" call :update %DEFAULT_VERSION% & goto :EOF
if /i "%1" == "update-loader" call :update-loader %DEFAULT_VERSION% & goto :EOF
if /i "%1" == "refresh" call :refresh_all & goto :EOF
if /i "%1" == "add" call :add %DEFAULT_VERSION% %2 & goto :EOF

if "%2" == "" call :update %1 & goto :EOF
if /i "%2" == "update-packwiz" call :update-packwiz & goto :EOF
if /i "%2" == "export" call :export %1 & goto :EOF
if /i "%2" == "update" call :update %1 & goto :EOF
if /i "%2" == "update-loader" call :update-loader %1 & goto :EOF
if /i "%2" == "refresh" call :refresh %1 & goto :EOF
if /i "%2" == "add" call :add %1 %3 & goto :EOF
goto :EOF

:update-packwiz
    go install github.com/packwiz/packwiz@latest
    goto :EOF

:export
    if not exist build\ mkdir build\
    pushd versions\%1 && (
        packwiz mr export
        popd
    )
    move versions\%1\*.mrpack build\
    goto :EOF

:update
    pushd versions\%1 && (
        packwiz update --all
        popd
    )
    goto :EOF

:update-loader
    pushd versions\%1 && (
        packwiz migrate loader latest
        popd
    )
    goto :EOF

:refresh_all
    for /d %%d in (versions\*) do (
        pushd %%d && (
            packwiz refresh
            popd
        )
    )
    goto :EOF

:refresh
    pushd versions\%1 && (
        packwiz refresh
        popd
    )
    goto :EOF

:add
    pushd versions\%1 && (
        packwiz mr add %2
        popd
    )
    goto :EOF
