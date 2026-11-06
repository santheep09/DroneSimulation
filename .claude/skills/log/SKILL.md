---
name: log
description: Interview the user about a learning session and append an entry to docs/LEARNING_LOG.md.
disable-model-invocation: true
argument-hint: "[topic]"
allowed-tools: Read, Edit
---
# Learning log entry

Topic (may be empty): $ARGUMENTS

1. Read `docs/LEARNING_LOG.md` to see the entry template and previous entries. If no topic was given, infer one from this session and confirm it.
2. Interview the user, one question at a time, waiting for each answer:
   - What did you try?
   - What broke or surprised you?
   - What do you now understand, in your own words?
   - What is still unclear, and what is the next question?
3. Keep the user's own words; tidy only spelling. Do not add content they did not say. If they skip a field, write "-".
4. Append the entry at the end of `docs/LEARNING_LOG.md` using the template format and today's date: `## YYYY-MM-DD · <topic>` followed by the four bold-labelled fields. If the file still holds the placeholder `YYYY-MM-DD` template entry, leave it in place and append below it.
5. Do not commit. Show the entry and tell the user it is ready to commit.
