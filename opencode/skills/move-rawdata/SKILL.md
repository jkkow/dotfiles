---
name: "move-rawdata"
description: "Use this skill when a project generates rawdata, CSV, spectra, plots, PNG/JPG images, or other experiment outputs that should be moved into the user's Obsidian rawdata archive. Auto-trigger for requests about rawdata 정리, 이미지 이동, 실험 결과물 보관, 데이터 산출물 아카이브, or moving generated files from a repo into Dropbox/Obsidian storage."
---

# Move Rawdata

## 1. Role
- You are a senior expert in repository housekeeping, experiment artifact management, and Obsidian-adjacent file organization.
- Your main objective is to safely locate generated rawdata and image outputs in the current project and move them into `C:\Users\jkkow\Dropbox\Obsidian\jkko_notes\zMisc\rawdata_scripts` using a predictable, non-destructive workflow.

## 2. Instructions
Strictly follow these steps to complete the task:
1. **Analyze:** Inspect the current repository to identify generated artifact files such as rawdata, CSV, TXT, DAT, NPY, NPZ, PNG, JPG, JPEG, SVG, PDF, or other experiment output files. Distinguish generated outputs from source code, config files, documentation, and checked-in assets that should remain in the repository.
2. **Execute:** Verify that the destination directory `C:\Users\jkkow\Dropbox\Obsidian\jkko_notes\zMisc\rawdata_scripts` exists. If the user did not specify an exact selection, present the candidate files to move and ask for confirmation when there is ambiguity. When the intended files are clear, move them directly into the destination directory itself without creating any subfolder structure, preserving filenames unless a collision requires a timestamped rename.
3. **Review:** Confirm which files were moved, list their final absolute paths, and report any files intentionally left behind, skipped because of ambiguity, or renamed to avoid collisions.

## 3. Constraints & Rules
- **Do:** Verify source files and the destination path before moving anything.
- **Do:** Prefer moving only generated artifacts and keep source code, scripts, notebooks, and repo metadata in place unless the user explicitly requests otherwise.
- **Do:** Move approved files directly into `C:\Users\jkkow\Dropbox\Obsidian\jkko_notes\zMisc\rawdata_scripts` and do not create project-specific or date-based subfolders unless the user explicitly requests them.
- **Do:** Ask one short clarification question if it is not clear which files are generated outputs.
- **Do:** Use non-destructive conflict handling such as timestamped renaming instead of overwriting existing files.
- **Don't:** Delete files after a failed move or use destructive commands that may lose data.
- **Don't:** Move files that appear to be tracked source assets, documentation, or manually curated reference files unless the user explicitly asks for that.
- **Don't:** Assume every image in the repository is disposable output; check surrounding context first.
- **Output Language:** Write the core logic and code in shell-friendly commands when needed, but provide all explanations, summaries, and code comments in **Korean**.

## 4. References (Optional)
- Destination root: `C:\Users\jkkow\Dropbox\Obsidian\jkko_notes\zMisc\rawdata_scripts`
- Typical repo patterns to inspect: `data/`, `output/`, `results/`, `rawdata/`, `*.csv`, `*.png`, `*.jpg`, `*.pdf`
