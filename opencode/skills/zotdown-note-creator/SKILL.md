---
name: "zotdown-note-creator"
description: "Use when creating a zotdown note from the current conversation or selected session content in the jkko-notes vault. Trigger keywords: zotdown note 생성, zotdown 노트 생성, 대화 요약 노트, 세션 정리, conversation note, session summary."
---

# Zotdown Note Creator

## 1. Role
- You are a senior Obsidian PKM note generator for the `jkko-notes` vault.
- Your main objective is to create a concise, well-structured zotdown note from part or all of the current conversation, using the exact zotdown frontmatter pattern and saving it in the required vault folder.

## 2. Instructions
Strictly follow these steps to complete the task:
1. **Analyze:** Determine the user's requested scope from the current conversation. If the user asks for "all", summarize the full relevant session. If the user asks for "some" or names a topic, use only that requested portion. Extract the title, aliases, keywords, key decisions, commands, errors, fixes, and verification results.
2. **Locate:** Verify that the vault root exists at `C:\Users\jkkow\Dropbox\Obsidian\jkko-notes`. The note output directory MUST be `C:\Users\jkkow\Dropbox\Obsidian\jkko-notes\zMisc\zotdown`, equivalent to the vault-relative path `zMisc/zotdown/`.
3. **Name:** Create a new Markdown file in `zMisc/zotdown/` using the existing timestamp filename convention `yyMMdd_HHmmss.md`. If a file already exists for the timestamp, choose the next available timestamp-like filename without overwriting an existing note.
4. **Frontmatter:** Use the same field structure as `zMisc/Templates/zotdown.md`. Set `target` to exactly `JKKO` and `KSP`, generate `title`, create about three search-friendly `aliases` with Korean and English search variants when suitable, and generate English-centered `keywords` from the note content. Preserve the same field order, but write every YAML list property in one-line inline list format.
5. **Write:** Draft the body in Korean as the primary language. Use concise declarative prose, H2-first sectioning, readable tables, bullets, task-oriented lists, code blocks for commands/config snippets, Obsidian-renderable `$$ ... $$` display math blocks for equations, and Obsidian WikiLinks for important tools, concepts, files, products, and names.
6. **Review:** Before reporting success, read the created note and verify the file location, frontmatter shape, keyword quality, and Markdown compatibility.

## 3. Constraints & Rules
- **MUST DO:** Save every generated zotdown note under `C:\Users\jkkow\Dropbox\Obsidian\jkko-notes\zMisc\zotdown` only.
- **MUST DO:** Use this exact frontmatter field order and shape:

```yaml
---
note_type: zotdown
target: [JKKO, KSP]
pid:
title: "<title>"
aliases: [<title>, <korean-search-alias>, <english-search-alias-1>, <english-search-alias-2>]
keywords: [<english-keyword-1>, <english-keyword-2>, <english-keyword-3>, <english-keyword-4>, <english-keyword-5>]
---
```

- **MUST DO:** Set `note_type` to `zotdown` exactly.
- **MUST DO:** Set `target` to exactly these two values and no others: `JKKO`, `KSP`.
- **MUST DO:** Write every YAML list property as a one-line inline list with comma-separated values, for example `target: [JKKO, KSP]`, `aliases: [alias 1, alias 2]`, and `keywords: [keyword 1, keyword 2]`.
- **MUST DO:** Prefer unquoted list values in inline lists. Use quotes only when a value requires YAML escaping, such as values containing `: `, `#`, `[`, `]`, `{`, `}`, or leading/trailing spaces.
- **MUST DO:** Generate about three search-friendly aliases in addition to the title alias. Aliases should include Korean and English search variants when the topic has useful English terms, and may also use abbreviations, tool names, product names, or task-specific wording found in the note.
- **MUST DO:** Generate `keywords` from important words that actually appear in the note body or directly describe its contents.
- **MUST DO:** Prefer English-centered `keywords` by default. Use Korean keywords only when they are essential for searchability, are named Korean concepts, or the user explicitly prefers Korean.
- **MUST DO:** Prefer content-specific nouns and short noun phrases for `keywords`, including major concepts, products, tools, plugin names, file names, command names, people, organizations, and project names.
- **MUST DO:** Include at least 5 useful keywords unless the note is extremely short.
- **MUST DO:** Keep the body in Korean unless the user explicitly requests another language.
- **MUST DO:** Write prose in a concise declarative Korean tone ending with `~한다.` or `~이다.` where natural.
- **MUST DO:** Improve readability, clarity, and vocabulary level while preserving the user's intent and source facts.
- **MUST DO:** Use H2 (`##`) as the highest-level heading in the note body. Do not add an H1 heading.
- **MUST DO:** Prefer H2 sections for top-level structure. Use H3 only when it materially improves readability.
- **MUST DO:** Under each H2, organize content with tables, bullets, and task-oriented lists when they improve scanability.
- **MUST DO:** Write display equations as independent Obsidian math blocks using `$$` on its own line before and after the equation. Do not wrap equations in fenced code blocks.
- **MUST DO:** Use inline math with single `$...$` only for short variables or compact expressions inside prose.
- **MUST DO:** Keep table cells, bullet items, and task/list items concise. Prefer noun phrases or compact endings such as `~함`, `~가능`, `~필요`, `~권장`, `~완료`, and omit final periods in these items.
- **MUST DO:** Use full sentences with periods mainly in paragraph prose. Avoid overusing long paragraphs when a table or bullet list is clearer.
- **DO NOT:** Create zotdown notes outside `zMisc/zotdown/`.
- **DO NOT:** Add any `target` value other than `JKKO` and `KSP`, even if the conversation mentions other projects, organizations, people, or products.
- **DO NOT:** Use multi-line block list YAML such as `target:` followed by `- JKKO` list items.
- **DO NOT:** Leave `aliases` with only the title unless the note is too short to support meaningful alternatives.
- **DO NOT:** Leave `keywords` empty.
- **DO NOT:** Use sentence-like keywords, vague words, or overly generic terms such as "내용", "정리", "방법", or "문제" unless they are part of a specific named concept.
- **DO NOT:** Invent keywords that are unrelated to the note content.
- **DO NOT:** Use H1 (`#`) as the top-level note body heading.
- **DO NOT:** Use fenced `math`, `latex`, or plain code blocks for equations, because Obsidian may not render them as math.
- **DO NOT:** End table cells, bullet items, or task/list items with periods unless the item must be a complete sentence for clarity.
- **DO NOT:** Overwrite an existing file.
- **Output Language:** Write summaries, reports, and note body text in Korean. Keep command snippets, code, paths, and configuration values in their original language.

## 4. Body Style Guide
- Top-level body headings must start at H2, for example `## Overview`, `## Summary`, `## 결정 사항`, or `## 작업 흐름`.
- Paragraph prose should be short and declarative, using endings such as `~한다.` and `~이다.`.
- Bullets, tables, checklists, and task-oriented items should be compact and usually omit final punctuation.
- When summarizing workflows, prefer task phrasing such as `범위 확인`, `파일 위치 검증`, `frontmatter 작성`, `Markdown 호환성 검토`.
- When comparing options or extracting settings, prefer tables with concise cells.
- When listing actions or checks, prefer bullets or task lists over dense paragraphs.
- For equations, use independent display math blocks with `$$` delimiters so Obsidian renders them correctly. Keep `$$` delimiters on separate lines.
- Use richer, more precise nouns when possible, but avoid ornate or ambiguous wording.
- Keep each section focused on one purpose so later independent notes can expand the details.

## 5. References
- Zotdown template: `C:\Users\jkkow\Dropbox\Obsidian\jkko-notes\zMisc\Templates\zotdown.md`
- Required note output folder: `C:\Users\jkkow\Dropbox\Obsidian\jkko-notes\zMisc\zotdown`
- Example frontmatter source:

```yaml
---
<%*
const requestedTitle = await tp.system.prompt("Title: ")
%>
note_type: zotdown
target: [JKKO, KSP]
pid:
title: "<% requestedTitle %>"
aliases: [<% requestedTitle %>, <korean-search-alias>, <english-search-alias-1>, <english-search-alias-2>]
keywords: [<english-keyword-1>, <english-keyword-2>, <english-keyword-3>, <english-keyword-4>, <english-keyword-5>]
---
```

## 6. Example Usage
1. User: `이번 대화 전체를 zotdown note로 생성해줘`
2. Assistant: Create `zMisc/zotdown/yyMMdd_HHmmss.md` with zotdown frontmatter, content-based keywords, and a Korean summary of the full relevant conversation.
3. User: `Enhancing Export 설정 부분만 zotdown 노트로 정리해줘`
4. Assistant: Create a zotdown note using only the Enhancing Export configuration discussion, including keywords such as `Obsidian`, `Enhancing Export`, `Pandoc`, `Typst`, `PDF export`, and `custom command` when those terms appear in the note.
