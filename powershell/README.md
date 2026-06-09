# PowerShell 프로필

이 폴더는 Windows PowerShell 환경에서 사용하는 셸 프로필 설정을 관리합니다. 저장소의 `powershell/` 폴더를 `$HOME\.config\powershell`로 연결하고, 실제 PowerShell 프로필 파일에서 이 폴더의 스크립트를 dot-source 해서 로드하는 구조입니다.

## 역할

- PowerShell 시작 시 공통 인코딩과 culture 설정을 적용합니다.
- 자주 쓰는 별칭과 함수는 `powershell_alias.ps1`에서 관리합니다.
- 프롬프트, PSReadLine, zoxide, yazi 같은 셸 모듈 초기화는 `setup_modules.ps1`에서 관리합니다.
- dotfiles 저장소의 설정을 `$HOME\.config\powershell` 경로로 노출해 SSH 세션과 일반 터미널에서 같은 설정을 쓰도록 합니다.

## 파일 관계

- `Microsoft.PowerShell_profile.ps1`: PowerShell 프로필 엔트리포인트입니다. UTF-8 인코딩과 culture를 먼저 설정한 뒤, 아래 두 파일을 로드합니다.
- `powershell_alias.ps1`: 사용자 alias와 편의 함수를 정의합니다.
- `setup_modules.ps1`: yazi wrapper, zoxide hook, PSReadLine vi mode, starship 초기화를 담당합니다.
- `README.md`: 이 폴더의 구조와 사용법을 설명합니다.

실제 로드 흐름은 다음과 같습니다.

```text
$PROFILE
  -> $HOME\.config\powershell\Microsoft.PowerShell_profile.ps1
      -> $HOME\.config\powershell\powershell_alias.ps1
      -> $HOME\.config\powershell\setup_modules.ps1
```

현재 Windows 환경에서는 `$PROFILE`이 보통 다음 위치를 가리킵니다.

```powershell
C:\Users\<user>\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

이 파일이 `$HOME\.config\powershell\Microsoft.PowerShell_profile.ps1`을 직접 실행하거나, 설치 스크립트가 프로필 파일을 올바른 위치에 연결해야 합니다.

## 설치

PowerShell 자체는 `winget` 또는 저장소 설치 스크립트로 설치할 수 있습니다.

```powershell
winget install --id Microsoft.PowerShell --exact --scope machine

# 또는 dotfiles 설치 스크립트 사용
pwsh .\installation\install.ps1 -Tools powershell
```

전체 dotfiles 설치가 필요하면 저장소 루트에서 다음 명령을 사용합니다.

```powershell
pwsh .\installation\install.ps1 -All
```

## 연결 구조

이 저장소는 `powershell/` 폴더 전체를 `$HOME\.config\powershell`로 연결해서 사용합니다.

- source: `powershell/`
- target: `$HOME\.config\powershell`

수동으로 연결해야 할 경우 다음 명령을 사용할 수 있습니다.

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\powershell" -Target "C:\path\to\dotfiles\powershell" -Force
```

## 사용법

새 PowerShell 세션을 열면 프로필이 자동으로 로드됩니다. 현재 세션에서 다시 적용하려면 다음 명령을 실행합니다.

```powershell
. $PROFILE
```

인코딩과 culture 적용 여부는 다음 명령으로 확인합니다.

```powershell
[Console]::InputEncoding.WebName
[Console]::OutputEncoding.WebName
$OutputEncoding.WebName
[System.Threading.Thread]::CurrentThread.CurrentCulture.Name
```

기대값은 다음과 같습니다.

```text
utf-8
utf-8
utf-8
en-US
```

## 주의 사항

- `setup_modules.ps1`의 PSReadLine 예측 설정은 대화형 콘솔에서만 적용됩니다. SSH, 리디렉션, 자동화 실행 환경에서는 오류를 피하기 위해 건너뜁니다.
- `starship`은 `$HOME\.config\starship\starship.toml`이 있을 때만 초기화됩니다.
- `y` 함수는 `yazi.exe` 실행 후 마지막 작업 디렉터리로 PowerShell 위치를 이동합니다.
- `cd` 함수는 `zoxide add .`를 함께 실행하도록 재정의되어 zoxide 데이터베이스를 자동 갱신합니다.

## 검증

문법 확인은 다음 명령으로 수행합니다.

```powershell
pwsh -NoProfile -NoLogo -Command "Get-Command -Syntax .\powershell\Microsoft.PowerShell_profile.ps1"
pwsh -NoProfile -NoLogo -Command "Get-Command -Syntax .\powershell\setup_modules.ps1"
```

프로필 로드 확인은 다음 명령을 사용합니다.

```powershell
pwsh -NoLogo -Command '[Console]::InputEncoding.WebName; [Console]::OutputEncoding.WebName; $OutputEncoding.WebName; [System.Threading.Thread]::CurrentThread.CurrentCulture.Name'
```
