<template lang="pug">
.info-redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('プロフィール')
Setup.setDescription('エノキ電気代表・ときえのき（jikantoki）の経歴、実績、保有資格、スキル一覧です。')

definePageMeta({
  middleware: [
    () => {
      return navigateTo({ path: '/', query: { tab: 'profile' } }, { redirectCode: 301 })
    },
  ],
})

onMounted(() => {
  navigateTo({ path: '/', query: { tab: 'profile' } }, { replace: true })
})
</script>
