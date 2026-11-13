<template lang="pug">
.redirect-container
</template>

<script setup lang="ts">
import Setup from '@/js/setup'

Setup.setTitle('YouTube')
Setup.setDescription('ときえのき（エノキ電気）の公式YouTubeチャンネルへリダイレクトします。')

definePageMeta({
  middleware: [
    () => {
      return navigateTo('https://www.youtube.com/@jikantoki', {
        external: true,
        redirectCode: 301,
      })
    },
  ],
})

onMounted(() => {
  window.location.href = 'https://www.youtube.com/@jikantoki'
})
</script>
