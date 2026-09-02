# Opencode Skills Repository - Agent Guidelines

This `AGENTS.md` file provides comprehensive context, rules, and style guidelines for AI coding agents operating within the `opencode skills` repository. It serves as the definitive source of truth for how to read, create, and modify skills.

## 1. Project Overview & Architecture

This repository contains "skills" for the Opencode CLI AI agent. A "skill" is a highly structured prompt or instruction set that tells the AI agent how to perform a specific task, adopt a specific persona, or follow a specialized workflow.

Rather than containing application source code (like Python, TypeScript, or Java), this repository contains **Prompt Engineering** source code in the form of Markdown files. Therefore, your primary duty here is to write exceptional, highly compliant prompts that other AI agents will understand and execute flawlessly.

## 2. Directory & File Structure

The repository structure is flat and strictly organized by skill:
- Each skill **MUST** have its own dedicated directory.
- The directory name should use lowercase English letters and hyphens (`kebab-case`) or underscores (`snake_case`). Example: `make_skill`, `modern-git-commit`, `react-testing-guide`.
- Inside each skill directory, there **MUST** be exactly one primary definition file named exactly `SKILL.md`.

## 3. Build, Lint, and Test Commands

Because this repository consists entirely of Markdown prompt files, traditional build tools (like `npm run build` or `cargo build`) and test frameworks (like `pytest` or `jest`) are not applicable.

### 3.1. Build Command
- **Build**: No build step is required. Skills are interpreted dynamically at runtime by the Opencode agent.

### 3.2. Lint Command
- **Lint**: Use `markdownlint` (if installed globally or in the environment) to ensure consistent Markdown formatting.
  - **Check all files**: `markdownlint "**/*.md"`
  - **Check a single file**: `markdownlint "skill-name/SKILL.md"`

### 3.3. Test Command
- **Automated Tests**: There are no automated unit tests.
- **Running a Single Test (Manual Verification)**: To "test" a single skill:
  1. Ensure the skill is saved locally in `~/.config/opencode/skills/your-skill-name/SKILL.md`.
  2. Open a new terminal and invoke the Opencode CLI agent.
  3. Prompt the agent with a request that matches the Korean or English keywords defined in the skill's `description` frontmatter.
  4. Observe the agent's behavior. Verify that it strictly adheres to the Role, Workflow, and Constraints defined in your `SKILL.md`.

## 4. Code Style & Guidelines (Prompt Engineering)

When creating or modifying a `SKILL.md` file, you are writing code for an LLM. You must follow these strict prompt engineering guidelines.

### 4.1. The SKILL.md Structure
Every `SKILL.md` file must be based on the `make_skill/skill_template.md` pattern.

#### 4.1.1. YAML Frontmatter (Critical for Auto-Triggering)
The file must start with valid YAML frontmatter containing `name` and `description`.
- `name`: The exact name of the skill directory.
- `description`: 1-2 concise sentences explaining exactly when the AI should auto-trigger this skill. **Crucially, you must include relevant Korean keywords** in the description to ensure it triggers correctly on natural language prompts from Korean users.

Example:
```yaml
---
name: "modern-git-commit"
description: "git commit, 현대적이고 가독성 좋은, 보안에 충실한 git commit 메시지 자동 작성 및 커밋 스킬. 깃 커밋 작성, 안전한 커밋, 시큐어 코딩."
---
```

#### 4.1.2. Core Sections (H2 Headers)
The body of the `SKILL.md` must use Markdown H2 headings and structured lists. Do not invent new sections unless absolutely necessary.
1. **## 1. Role**: Describe the persona, expertise domain, and main objective of the agent.
2. **## 2. Workflow** (or Instructions): Provide a strict, step-by-step numbered list (`1.`, `2.`, `3.`) of actions the agent must take.
3. **## 3. Constraints & Rules**: Emphasize strict behavioral guardrails using a "MUST DO:" and "DO NOT:" bulleted format.
4. **## 4. References** (Optional): Provide external links, internal file paths, or documentation that the agent might need context on.

### 4.2. Language Conventions (Cross-Lingual Strategy)
To maximize LLM compliance while maintaining a great user experience:
- **Core Logic in English**: The Role, Workflow, and Constraints sections should be written entirely in **English**. LLMs follow complex, multi-step instructions much more reliably when prompted in English.
- **User Interaction in Korean**: Within the constraints or workflow, explicitly instruct the agent to provide all summaries, explanations, warnings, and conversational output to the user in **Korean**. (e.g., *"Provide all explanations to the user in Korean."*).

### 4.3. Formatting Best Practices
- Use bold text (`**critical instruction**`) to emphasize mandatory steps or constraints.
- Use inline code blocks (`` `file.txt` ``) for file names, paths, variables, or terminal commands.
- Be extremely explicit. Avoid ambiguity. Instead of "Check for secrets," write "Run `git diff` and scan for API keys or credentials. If found, immediately abort."

## 5. Adding a New Skill
Whenever you are asked to create a new skill, you **must** use the `make_skill/skill_template.md` as your starting point.
1. Ask the user for the intended skill name and path (Local project `.opencode/` vs Global `~/.config/opencode/`).
2. Create the directory.
3. Generate the `SKILL.md` following the template and language conventions above.

## 6. Git & Version Control Guidelines
If you are asked to commit changes to this repository:
- Follow the **Conventional Commits** specification rigidly (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`).
  - Example: `feat(react): add new react testing skill`
  - Example: `docs(make-skill): update template instructions`
- **Security Check**: Never commit sensitive data. Review `git diff --cached` before executing the commit.

## 7. Error Handling & Guardrails
When defining error handling behavior inside a skill's prompt:
- Instruct the agent to halt execution immediately if a critical prerequisite is missing.
- Instruct the agent to inform the user of the exact issue in Korean, rather than hallucinating a solution.
- Example constraint to include: *"If no test framework configuration is found, DO NOT write tests blindly. Stop and ask the user for clarification in Korean."*

## 8. Integration with Other Tools (Cursor/Copilot)
Currently, there are no specific `.cursorrules` or `.github/copilot-instructions.md` files in this repository.
However, if utilizing AI assistants outside of Opencode within this directory:
- They must adhere strictly to the Cross-Lingual Strategy (English logic, Korean output).
- They must format all new skills exactly as defined in Section 4.1.

## 9. Tool Usage Strategies within Prompts
As you design new `SKILL.md` workflows, you are often directing an AI on how to use its available tools (e.g., `bash`, `read`, `edit`, `glob`, `grep`).
- **Parallelism**: Instruct the agent to run independent searches or tests in parallel.
  - *Example prompt snippet*: "Run `git status` and `git diff` in parallel."
- **Path Resolution**: Emphasize the absolute necessity of absolute paths.
  - *Example prompt snippet*: "Before reading a file, resolve its absolute path from the project root."
- **Verification Loop**: Build testing and validation into the workflow.
  - *Example prompt snippet*: "After editing, run the linter. If errors occur, attempt to fix them up to 3 times before asking the user."

## 10. Core Philosophy: The User is in Control
- **No Unsolicited Reverts**: Never instruct an agent to revert code without explicit user permission.
- **Explain Before Action**: For any destructive file operation, instruct the agent to explain what it is about to do.
- **Assume Best Intentions**: If a user cancels a tool call, the agent should politely ask for an alternative direction in Korean.

## 11. Persona and Tone Guidelines
- **Professional & Concise**: AI agents must be instructed to be direct. Avoid conversational filler like "Okay, I will now do this."
- **Clarity over Brevity**: When explaining an error or a security risk (e.g., exposed secrets in a commit), prioritize extreme clarity.

## 12. Examples of Excellent vs Poor Prompting
### Excellent (Explicit, English, Structured)
```markdown
1. **Analyze**: Run `npm test`.
2. **Review**: If tests fail, read the failing test file.
3. **Fix**: Use the `edit` tool to fix the logic. Provide the summary of changes in Korean.
```

### Poor (Vague, Mixed Languages, Unstructured)
```markdown
테스트를 돌려보고 실패하면 코드를 고치세요. (Run tests and fix if failed).
Make sure it works.
```
