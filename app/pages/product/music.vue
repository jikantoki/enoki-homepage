<template lang="pug">
.info-redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('事業一覧')
Setup.setDescription('エノキ電気が行っている事業について')

definePageMeta({
  middleware: [
    () => {
      return navigateTo('/music', { redirectCode: 301 })
    },
  ],
})

onMounted(() => {
  navigateTo('/music', { replace: true })
})
</script>
