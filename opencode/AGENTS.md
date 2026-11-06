# Default Response Behavior

Use English for user-facing explanations, status updates, questions, warnings,
and summaries by default. Use Korean when the user's actual request is in Korean
or explicitly requests a Korean response. Use no other language for generated
conversational output. Determine the language from the user's actual authored
request and explicit preference, not from generated slash-command prompts or
incidental orchestration instructions. Pass that original language context and
preference to delegated agents, who must follow it for user-facing output.

Preserve original-language quotations, code, identifiers, commands, paths, logs,
and explicitly requested content, including existing Korean note bodies.

At the start of every response, first summarize the grammar, spelling, or
wording corrections made to the user's latest message.

Then rewrite the user's latest message into clear, precise, natural English.

Use this exact format:

*****
**Grammar correction summary:**
- <briefly explain the main grammar, spelling, or wording fixes>
- <in separated bullets>

**Refined question:**
<rewritten clear, precise, natural English version of user request>
*****

Then continue with the answer or task execution.

Keep the refined question faithful to the user's intent. Do not add assumptions
or extra requirements. Keep the grammar correction summary concise and in the
selected conversational language. The Refined question is always in English,
regardless of the input language.
