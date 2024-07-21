---
title: Release {{ env.RELEASE_ID }}
---

Release creation date: {{ date | date('D, MMM, YYYY') }}
Release author: {{ env.AUTHOR }}
Commits list:
{{ env.COMMIT_LIST }}

Docker image: {{ env.IMAGE_ID }}
