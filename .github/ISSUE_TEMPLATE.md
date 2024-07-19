---
title: ${{ tools.context.actor }} made release ${{ env.VERSION }}
assignees: ${{ tools.context.actor }}
---
data: {{ date | date('dddd, MMMM Do') }}
author: ${{ tools.context.actor }}
version: ${{ env.VERSION }}
docker-image: cr.yandex/${{ env.REGISTRY_ID }}/app:${{ github.run_number }}
commits: