<template lang="pug">
v-app.error-page-app
  .notfound-page-root(
    style="width: 100%; height: 100%;"
    :class="settings.hidden.isAndroid15OrHigher ? 'top-android-15-or-higher' : ''"
  )
    //- ================= トップバー（他ページと統一） =================
    v-card-actions.notfound-page-header
      v-btn(
        icon="mdi-arrow-left"
        variant="text"
        @click="handleBack"
      )
      p.header-title {{ displayStatusCode }} {{ is404 ? 'NOT FOUND' : 'ERROR' }}
      v-spacer

      //- 効果音トグルボタン
      v-btn(
        :icon="soundEnabled ? 'mdi-volume-high' : 'mdi-volume-off'"
        variant="text"
        :title="soundEnabled ? '効果音: ON' : '効果音: OFF'"
        @click="toggleSound"
      )

      //- ホームボタン
      v-btn(
        icon="mdi-home-outline"
        variant="text"
        title="トップページ"
        @click="handleGoHome"
      )

    //- ================= メインスクロールエリア =================
    v-card-text.notfound-page-content(ref="contentContainer")
      //- 背景キャンバス（サイバーパーティクル & 回路網）
      canvas.cyber-canvas(ref="canvasRef")

      //- CRTスキャンライン & ネオングロー
      .crt-overlay
      .ambient-glow.glow-cyan
      .ambient-glow.glow-magenta

      .content-wrapper
        //- 404 グリッチヘッダー
        .glitch-wrapper
          .glitch-code(:data-text="displayStatusCode") {{ displayStatusCode }}
          .glitch-badge
            v-icon(size="15" color="error") mdi-alert-circle-outline
            span STATUS_{{ displayStatusCode }} // {{ is404 ? 'SIGNAL_TERMINATED' : 'ANOMALY_DETECTED' }}

        //- タイトル & 説明
        h1.error-title {{ displayTitle }}
        p.error-description
          | {{ displaySubtitle }}
          br.d-none.d-sm-inline
          | 指定座標:
          span.path-highlight {{ currentPath }}

        //- ターミナル風自己診断コンソール
        .terminal-card
          .terminal-header
            .terminal-buttons
              span.term-btn.red
              span.term-btn.yellow
              span.term-btn.green
            span.terminal-title DIAGNOSTIC_CONSOLE // 自動診断システム
            span.terminal-status(:class="{ scanning: isScanning }")
              v-icon(size="14" :icon="isScanning ? 'mdi-loading mdi-spin' : 'mdi-check-circle'")
              | {{ isScanning ? 'SCANNING...' : 'SYSTEM_READY' }}

          .terminal-body(ref="terminalBodyRef")
            .terminal-line(v-for="(log, idx) in logs" :key="idx" :class="log.type")
              span.log-timestamp [{{ log.time }}]
              span.log-tag {{ log.tag }}
              span.log-text {{ log.text }}

          .terminal-actions
            v-btn.terminal-scan-btn(
              size="small"
              variant="tonal"
              color="primary"
              prepend-icon="mdi-radar"
              :loading="isScanning"
              @click="triggerReScan"
            )
              | 周波数を再探査 (RE-SCAN)
            span.terminal-hint ※探査レーダーを再照射して別タイムラインの痕跡を検索します

        //- プライマリアクションボタングループ
        .primary-actions
          v-btn.action-btn.btn-home(
            size="large"
            rounded="pill"
            elevation="6"
            prepend-icon="mdi-home"
            color="primary"
            @click="handleGoHome"
          )
            span.btn-text ホームへ帰還
            v-icon.ml-2(size="18") mdi-arrow-right

          v-btn.action-btn.btn-back(
            size="large"
            rounded="pill"
            variant="outlined"
            prepend-icon="mdi-arrow-left"
            @click="handleBack"
          )
            span.btn-text 直前のページへ戻る

        //- クイックワープセクション（正常稼働中の主要セクター）
        .quick-nav-section
          .section-heading
            v-icon(size="16" color="primary") mdi-compass-outline
            span.heading-text クイックワープ // 正常稼働中の主要セクター
          
          .warp-grid
            .warp-card(
              v-for="item in quickLinks"
              :key="item.path"
              @click="navigateTo(item.path)"
              @mouseenter="playBeep(800, 0.03)"
            )
              .warp-icon(:style="{ backgroundColor: item.bg, color: item.color }")
                v-icon(:icon="item.icon" size="22")
              .warp-info
                .warp-title {{ item.title }}
                .warp-desc {{ item.description }}
              v-icon.warp-arrow(size="18") mdi-chevron-right

    //- ================= ボトムナビゲーションバー =================
    BottomNav
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import type { NuxtError } from '#app'
import BottomNav from '@/components/common/BottomNav.vue'
import { useSettingsStore } from '@/stores/settings'

// ================= プロパティ & ルーティング =================
const props = defineProps<{
  error?: NuxtError | any
}>()

const router = useRouter()
const route = useRoute()
const settings = useSettingsStore()

// ステータスコード
const displayStatusCode = computed(() => {
  return Number(props.error?.statusCode) || 404
})

const is404 = computed(() => displayStatusCode.value === 404)

// タイトル & 説明文
const displayTitle = computed(() => {
  if (is404.value) return '存在しない周波数を受信しました'
  return '内部回路で量子異常が発生しました'
})

const displaySubtitle = computed(() => {
  if (is404.value) {
    return 'エノキ電気の量子探査レーダーが指定の座標をスキャンしましたが、応答信号が検出されませんでした。'
  }
  return 'システム内部で予期せぬ量子エラーが発生しました。コアプロセッサが自動保護モードに移行しています。'
})

// リクエストされたパス
const currentPath = computed(() => {
  if (props.error?.url) return props.error.url
  if (route?.fullPath && route.fullPath !== '/') return route.fullPath
  return '/lost-sector-unknown'
})

// ページメタデータ
useHead({
  title: `${displayStatusCode.value} - ${displayTitle.value} | エノキ電気`,
  meta: [
    {
      name: 'description',
      content: 'エノキ電気公式ホームページ - 404 Not Found',
    },
  ],
})

// クイックワープリンク一覧
const quickLinks = [
  {
    title: 'ソフトウェア一覧',
    description: 'Webツール・ゲーム・実験的アプリ',
    path: '/apps',
    icon: 'mdi-apps',
    color: '#38bdf8',
    bg: 'rgba(56, 189, 248, 0.15)',
  },
  {
    title: '音楽ライブラリ',
    description: 'オリジナル楽曲・アルバム・試聴',
    path: '/music',
    icon: 'mdi-music',
    color: '#a855f7',
    bg: 'rgba(168, 85, 247, 0.15)',
  },
  {
    title: 'プロフィール & 実績',
    description: 'ときえのき（エノキ電気）の紹介',
    path: '/profile',
    icon: 'mdi-account',
    color: '#f43f5e',
    bg: 'rgba(244, 63, 94, 0.15)',
  },
  {
    title: 'スポンサー',
    description: 'ご支援いただいている方々のご紹介',
    path: '/sponsors',
    icon: 'mdi-handshake-outline',
    color: '#10b981',
    bg: 'rgba(16, 185, 129, 0.15)',
  },
]

// ================= サウンド効果 (Web Audio API) =================
const soundEnabled = ref(true)
let audioCtx: AudioContext | null = null

const initAudio = () => {
  if (!audioCtx && typeof window !== 'undefined') {
    const AudioContextClass =
      window.AudioContext || (window as any).webkitAudioContext
    if (AudioContextClass) {
      audioCtx = new AudioContextClass()
    }
  }
}

const toggleSound = () => {
  soundEnabled.value = !soundEnabled.value
  if (soundEnabled.value) {
    playBeep(880, 0.08)
  }
}

const playBeep = (
  freq = 440,
  duration = 0.05,
  type: OscillatorType = 'sine',
) => {
  if (!soundEnabled.value) return
  try {
    initAudio()
    if (!audioCtx) return
    if (audioCtx.state === 'suspended') {
      audioCtx.resume()
    }
    const osc = audioCtx.createOscillator()
    const gain = audioCtx.createGain()
    osc.type = type
    osc.frequency.setValueAtTime(freq, audioCtx.currentTime)
    gain.gain.setValueAtTime(0.04, audioCtx.currentTime)
    gain.gain.exponentialRampToValueAtTime(
      0.0001,
      audioCtx.currentTime + duration,
    )
    osc.connect(gain)
    gain.connect(audioCtx.destination)
    osc.start()
    osc.stop(audioCtx.currentTime + duration)
  } catch (e) {
    // AudioContext政策への配慮
  }
}

const playCyberGlitchSound = () => {
  if (!soundEnabled.value) return
  playBeep(320, 0.06, 'sawtooth')
  setTimeout(() => playBeep(640, 0.08, 'square'), 40)
  setTimeout(() => playBeep(960, 0.1, 'sine'), 90)
}

// ================= ターミナル診断ログ =================
interface LogItem {
  time: string
  tag: string
  text: string
  type: 'info' | 'warn' | 'error' | 'success'
}

const getTimeString = () => {
  const now = new Date()
  return now.toTimeString().split(' ')[0]
}

const logs = ref<LogItem[]>([])
const terminalBodyRef = ref<HTMLElement | null>(null)
const isScanning = ref(false)

const addLog = (
  tag: string,
  text: string,
  type: 'info' | 'warn' | 'error' | 'success' = 'info',
) => {
  logs.value.push({
    time: getTimeString(),
    tag,
    text,
    type,
  })
  nextTick(() => {
    if (terminalBodyRef.value) {
      terminalBodyRef.value.scrollTop = terminalBodyRef.value.scrollHeight
    }
  })
}

const initializeLogs = () => {
  logs.value = []
  addLog('[SYS]', 'ENOKI QUANTUM KERNEL v4.3.1 ONLINE', 'info')
  addLog('[NET]', `SCANNING ROUTE: "${currentPath.value}"`, 'info')
  addLog('[GATEWAY]', 'Pinging quantum transceivers across timeline...', 'info')
  setTimeout(() => {
    addLog(
      '[WARN]',
      `STATUS_${displayStatusCode.value}: RESPONSE TIMEOUT / NO CARRIER`,
      'warn',
    )
  }, 220)
  setTimeout(() => {
    addLog(
      '[ERR]',
      is404.value
        ? 'TARGET SECTOR VACANT: ページが存在しません'
        : 'INTERNAL EXCEPTION DETECTED',
      'error',
    )
    addLog(
      '[SUGGEST]',
      '下部ナビゲーションバーまたはホームボタンからご移動ください',
      'success',
    )
  }, 500)
}

const scanResponses = [
  '探査波を再照射中... 全サブバンドで応答シグナルなし。',
  '時空座標を再計算中... 対象オブジェクトは事象の地平面を超えました。',
  '並行宇宙 (Timeline-Beta) を検索中... 該当データは消失しています。',
  '量子ノイズ 99.8% を検出。物理リンクは完全に切断されています。',
  '救難ビーコン応答: "エノキ電気ホームベースへの帰還を推奨"',
]

const triggerReScan = () => {
  if (isScanning.value) return
  isScanning.value = true
  playCyberGlitchSound()
  addLog('[RADAR]', 'RE-SCAN PROTOCOL ENGAGED...', 'info')

  let count = 0
  const interval = setInterval(() => {
    count++
    const randomFreq = (Math.random() * 900 + 100).toFixed(1)
    addLog('[SCAN]', `ANALYZING SUB-BAND ${randomFreq} MHz...`, 'info')
    playBeep(400 + count * 150, 0.03)

    if (count >= 3) {
      clearInterval(interval)
      const randomAnswer =
        scanResponses[Math.floor(Math.random() * scanResponses.length)]
      setTimeout(() => {
        addLog('[RESULT]', randomAnswer, 'warn')
        addLog(
          '[SYS]',
          '再探査完了: ホームまたはナビゲーションバーよりご移動ください。',
          'success',
        )
        isScanning.value = false
        playBeep(520, 0.15)
      }, 300)
    }
  }, 380)
}

// ================= ナビゲーションアクション =================
const handleGoHome = async () => {
  playBeep(880, 0.1)
  await clearError({ redirect: '/' })
}

const handleBack = () => {
  playBeep(660, 0.08)
  if (typeof window !== 'undefined' && window.history.length > 1) {
    router.back()
  } else {
    handleGoHome()
  }
}

const navigateTo = async (path: string) => {
  playBeep(740, 0.08)
  await clearError({ redirect: path })
}

// キーボードショートカット (ESC でホームへ戻る)
const handleKeyDown = (e: KeyboardEvent) => {
  if (e.key === 'Escape') {
    handleGoHome()
  }
}

// ================= HTML5 Canvas パーティクル & 回路網アニメーション =================
const canvasRef = ref<HTMLCanvasElement | null>(null)
let animationId: number | null = null

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  radius: number
  color: string
  baseAlpha: number
  alpha: number
}

const setupCanvas = () => {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  if (!ctx) return

  const container = canvas.parentElement
  let width = (canvas.width = container
    ? container.clientWidth
    : window.innerWidth)
  let height = (canvas.height = container
    ? container.clientHeight
    : window.innerHeight)

  const handleResize = () => {
    if (!canvas || !container) return
    width = canvas.width = container.clientWidth
    height = canvas.height = container.clientHeight
  }
  window.addEventListener('resize', handleResize)

  const mouse = {
    x: width / 2,
    y: height / 2,
    isActive: false,
    radius: 140,
  }

  const handleMouseMove = (e: MouseEvent) => {
    if (!container) return
    const rect = container.getBoundingClientRect()
    mouse.x = e.clientX - rect.left
    mouse.y = e.clientY - rect.top
    mouse.isActive = true
  }
  const handleTouchMove = (e: TouchEvent) => {
    if (!container || e.touches.length === 0) return
    const rect = container.getBoundingClientRect()
    mouse.x = e.touches[0].clientX - rect.left
    mouse.y = e.touches[0].clientY - rect.top
    mouse.isActive = true
  }
  const handleMouseLeave = () => {
    mouse.isActive = false
  }

  if (container) {
    container.addEventListener('mousemove', handleMouseMove)
    container.addEventListener('touchmove', handleTouchMove)
    container.addEventListener('mouseleave', handleMouseLeave)
  }

  const particleCount = Math.min(Math.floor((width * height) / 18000), 55)
  const particles: Particle[] = []
  const palette = ['#38bdf8', '#818cf8', '#f43f5e', '#ec4899', '#34d399']

  for (let i = 0; i < particleCount; i++) {
    const color = palette[Math.floor(Math.random() * palette.length)]
    const baseAlpha = Math.random() * 0.4 + 0.25
    particles.push({
      x: Math.random() * width,
      y: Math.random() * height,
      vx: (Math.random() - 0.5) * 0.7,
      vy: (Math.random() - 0.5) * 0.7,
      radius: Math.random() * 2 + 1,
      color,
      baseAlpha,
      alpha: baseAlpha,
    })
  }

  const render = () => {
    ctx.clearRect(0, 0, width, height)

    for (let i = 0; i < particles.length; i++) {
      const p = particles[i]

      p.x += p.vx
      p.y += p.vy

      if (p.x < 0) {
        p.x = 0
        p.vx *= -1
      } else if (p.x > width) {
        p.x = width
        p.vx *= -1
      }
      if (p.y < 0) {
        p.y = 0
        p.vy *= -1
      } else if (p.y > height) {
        p.y = height
        p.vy *= -1
      }

      if (mouse.isActive) {
        const dx = mouse.x - p.x
        const dy = mouse.y - p.y
        const dist = Math.sqrt(dx * dx + dy * dy)
        if (dist < mouse.radius) {
          const force = (mouse.radius - dist) / mouse.radius
          p.x -= (dx / dist) * force * 2.5
          p.y -= (dy / dist) * force * 2.5
          p.alpha = Math.min(p.baseAlpha + 0.4, 1)
        } else {
          p.alpha = p.baseAlpha
        }
      }

      ctx.beginPath()
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2)
      ctx.fillStyle = p.color
      ctx.globalAlpha = p.alpha
      ctx.shadowBlur = 6
      ctx.shadowColor = p.color
      ctx.fill()
      ctx.shadowBlur = 0

      for (let j = i + 1; j < particles.length; j++) {
        const p2 = particles[j]
        const dx = p.x - p2.x
        const dy = p.y - p2.y
        const dist = Math.sqrt(dx * dx + dy * dy)
        const maxDist = 110

        if (dist < maxDist) {
          const lineAlpha = (1 - dist / maxDist) * 0.22
          ctx.beginPath()
          ctx.moveTo(p.x, p.y)
          ctx.lineTo(p2.x, p2.y)
          ctx.strokeStyle = p.color
          ctx.globalAlpha = lineAlpha
          ctx.lineWidth = 0.8
          ctx.stroke()
        }
      }
    }

    ctx.globalAlpha = 1
    animationId = requestAnimationFrame(render)
  }

  render()

  return () => {
    window.removeEventListener('resize', handleResize)
    if (container) {
      container.removeEventListener('mousemove', handleMouseMove)
      container.removeEventListener('touchmove', handleTouchMove)
      container.removeEventListener('mouseleave', handleMouseLeave)
    }
    if (animationId) cancelAnimationFrame(animationId)
  }
}

let cleanupCanvas: (() => void) | undefined

onMounted(() => {
  initializeLogs()
  cleanupCanvas = setupCanvas()
  window.addEventListener('keydown', handleKeyDown)
})

onUnmounted(() => {
  if (cleanupCanvas) cleanupCanvas()
  window.removeEventListener('keydown', handleKeyDown)
  if (audioCtx) {
    audioCtx.close().catch(() => {})
  }
})
</script>

<style lang="scss" scoped>
// ================= ルートコンテナ（他ページと統一） =================
.error-page-app {
  font-family: 'Zen Maru Gothic', sans-serif;
  height: 100vh;
  height: 100dvh;
  overflow: hidden;
}

.notfound-page-root {
  display: flex;
  flex-direction: column;
  height: 100%;
  height: 100dvh;
  background-color: rgb(var(--v-theme-surface));
  color: rgb(var(--v-theme-on-surface));
  font-family: 'Zen Maru Gothic', sans-serif;
  position: relative;
  overflow: hidden;

  // トップバー
  .notfound-page-header {
    height: 56px;
    padding: 0 12px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    flex-shrink: 0;
    z-index: 10;
    background-color: rgb(var(--v-theme-surface));

    .header-title {
      font-size: 1.15rem;
      font-weight: 700;
      margin: 0 0 0 8px;
      letter-spacing: 0.05em;
    }
  }

  // メインスクロールエリア
  .notfound-page-content {
    flex: 1;
    overflow-y: auto;
    padding: 24px 16px 100px;
    -webkit-overflow-scrolling: touch;
    position: relative;

    .content-wrapper {
      max-width: 820px;
      margin: 0 auto;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
      position: relative;
      z-index: 5;
    }
  }
}

// ================= 背景キャンバス & エフェクト =================
.cyber-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.crt-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 2;
  background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.08) 50%);
  background-size: 100% 4px;
  opacity: 0.5;
}

.ambient-glow {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  pointer-events: none;
  z-index: 0;
  opacity: 0.18;

  &.glow-cyan {
    width: 400px;
    height: 400px;
    top: 5%;
    left: 10%;
    background: #0ea5e9;
  }

  &.glow-magenta {
    width: 450px;
    height: 450px;
    bottom: 10%;
    right: 10%;
    background: #e12378;
  }
}

// ================= 404 グリッチヘッダー =================
.glitch-wrapper {
  position: relative;
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 8px;
}

.glitch-code {
  font-size: clamp(5rem, 14vw, 8.5rem);
  font-weight: 900;
  line-height: 1;
  letter-spacing: 0.04em;
  font-family: 'Zen Maru Gothic', sans-serif;
  background: linear-gradient(
    135deg,
    rgb(var(--v-theme-on-surface)) 0%,
    #38bdf8 55%,
    #e12378 100%
  );
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  position: relative;
  text-shadow: 0 0 35px rgba(56, 189, 248, 0.3);
  animation: glitch-anim 4.5s infinite linear alternate-reverse;
  margin-bottom: 32px;

  &::before,
  &::after {
    content: attr(data-text);
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: inherit;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  &::before {
    left: 2px;
    text-shadow: -2px 0 #38bdf8;
    clip-path: polygon(0 20%, 100% 20%, 100% 45%, 0 45%);
    animation: glitch-anim-2 3s infinite linear alternate-reverse;
  }

  &::after {
    left: -2px;
    text-shadow: 2px 0 #e12378;
    clip-path: polygon(0 60%, 100% 60%, 100% 85%, 0 85%);
    animation: glitch-anim-3 2.5s infinite linear alternate-reverse;
  }
}

@keyframes glitch-anim {
  0% {
    transform: translate(0);
  }
  92% {
    transform: translate(0);
  }
  93% {
    transform: translate(-3px, 2px);
  }
  94% {
    transform: translate(3px, -1px);
  }
  95% {
    transform: translate(-2px, 1px);
  }
  96% {
    transform: translate(0);
  }
  100% {
    transform: translate(0);
  }
}

@keyframes glitch-anim-2 {
  0% {
    clip-path: polygon(0 15%, 100% 15%, 100% 30%, 0 30%);
    transform: translate(0);
  }
  90% {
    clip-path: polygon(0 10%, 100% 10%, 100% 35%, 0 35%);
    transform: translate(0);
  }
  92% {
    clip-path: polygon(0 40%, 100% 40%, 100% 65%, 0 65%);
    transform: translate(-4px, 2px);
  }
  94% {
    clip-path: polygon(0 20%, 100% 20%, 100% 45%, 0 45%);
    transform: translate(3px, -2px);
  }
  96% {
    clip-path: polygon(0 0%, 100% 0%, 100% 100%, 0 100%);
    transform: translate(0);
  }
  100% {
    clip-path: polygon(0 15%, 100% 15%, 100% 30%, 0 30%);
    transform: translate(0);
  }
}

@keyframes glitch-anim-3 {
  0% {
    clip-path: polygon(0 65%, 100% 65%, 100% 80%, 0 80%);
    transform: translate(0);
  }
  88% {
    clip-path: polygon(0 65%, 100% 65%, 100% 80%, 0 80%);
    transform: translate(0);
  }
  90% {
    clip-path: polygon(0 30%, 100% 30%, 100% 50%, 0 50%);
    transform: translate(4px, -1px);
  }
  93% {
    clip-path: polygon(0 75%, 100% 75%, 100% 95%, 0 95%);
    transform: translate(-3px, 1px);
  }
  96% {
    clip-path: polygon(0 0%, 100% 0%, 100% 100%, 0 100%);
    transform: translate(0);
  }
  100% {
    clip-path: polygon(0 65%, 100% 65%, 100% 80%, 0 80%);
    transform: translate(0);
  }
}

.glitch-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(var(--v-theme-error), 0.12);
  border: 1px solid rgba(var(--v-theme-error), 0.3);
  padding: 5px 14px;
  border-radius: 20px;
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.8rem;
  letter-spacing: 0.05em;
  color: rgb(var(--v-theme-error));
  margin-top: -8px;
}

// ================= タイトル & 説明 =================
.error-title {
  font-size: clamp(1.5rem, 3.8vw, 2.2rem);
  font-weight: 800;
  margin: 16px 0 10px;
  color: rgb(var(--v-theme-on-surface));
  letter-spacing: -0.01em;
}

.error-description {
  font-size: clamp(0.92rem, 1.9vw, 1.05rem);
  line-height: 1.7;
  color: rgba(var(--v-theme-on-surface), 0.75);
  max-width: 640px;
  margin-bottom: 24px;

  .path-highlight {
    color: #0284c7;
    background: rgba(56, 189, 248, 0.12);
    padding: 2px 8px;
    border-radius: 6px;
    font-family: 'Courier New', Courier, monospace;
    font-weight: 600;
    word-break: break-all;
    border: 1px dashed rgba(56, 189, 248, 0.5);
    margin-left: 4px;
  }
}

// ================= ターミナル風自己診断コンソール =================
.terminal-card {
  width: 100%;
  background: rgba(var(--v-theme-surface), 0.85);
  border: 1px solid rgba(var(--v-theme-on-surface), 0.12);
  border-radius: 14px;
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12),
    inset 0 0 20px rgba(56, 189, 248, 0.04);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  overflow: hidden;
  margin-bottom: 28px;
  text-align: left;
}

.terminal-header {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  background: rgba(var(--v-theme-on-surface), 0.03);
  border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.06);
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.75rem;

  .terminal-buttons {
    display: flex;
    gap: 6px;
    margin-right: 14px;

    .term-btn {
      width: 10px;
      height: 10px;
      border-radius: 50%;

      &.red {
        background: #ef4444;
      }
      &.yellow {
        background: #f59e0b;
      }
      &.green {
        background: #10b981;
      }
    }
  }

  .terminal-title {
    color: rgba(var(--v-theme-on-surface), 0.65);
    letter-spacing: 0.05em;
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .terminal-status {
    display: flex;
    align-items: center;
    gap: 5px;
    color: #10b981;
    font-weight: 700;

    &.scanning {
      color: #0284c7;
    }
  }
}

.terminal-body {
  padding: 14px 18px;
  max-height: 140px;
  overflow-y: auto;
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.82rem;
  line-height: 1.6;

  &::-webkit-scrollbar {
    width: 6px;
  }
  &::-webkit-scrollbar-thumb {
    background: rgba(var(--v-theme-on-surface), 0.15);
    border-radius: 3px;
  }
}

.terminal-line {
  display: flex;
  gap: 8px;
  margin-bottom: 4px;
  word-break: break-all;

  .log-timestamp {
    color: rgba(var(--v-theme-on-surface), 0.4);
    flex-shrink: 0;
  }

  .log-tag {
    font-weight: 700;
    flex-shrink: 0;
  }

  .log-text {
    flex: 1;
  }

  &.info {
    .log-tag {
      color: #0284c7;
    }
    .log-text {
      color: rgba(var(--v-theme-on-surface), 0.85);
    }
  }

  &.warn {
    .log-tag {
      color: #d97706;
    }
    .log-text {
      color: #b45309;
    }
  }

  &.error {
    .log-tag {
      color: #e11d48;
    }
    .log-text {
      color: #be123c;
    }
  }

  &.success {
    .log-tag {
      color: #059669;
    }
    .log-text {
      color: #047857;
    }
  }
}

.terminal-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 16px;
  background: rgba(var(--v-theme-on-surface), 0.02);
  border-top: 1px solid rgba(var(--v-theme-on-surface), 0.05);
  flex-wrap: wrap;
  gap: 8px;

  .terminal-scan-btn {
    text-transform: none;
    font-family: 'Courier New', Courier, monospace;
    font-weight: 700;
  }

  .terminal-hint {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), 0.5);
  }
}

// ================= プライマリアクション =================
.primary-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
  width: 100%;
  flex-wrap: wrap;
  margin-bottom: 36px;

  .action-btn {
    min-width: 190px;
    font-weight: 700;
    letter-spacing: 0.03em;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);

    &.btn-home {
      box-shadow: 0 6px 20px rgba(var(--v-theme-primary), 0.35);

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 26px rgba(var(--v-theme-primary), 0.5);
      }
    }

    &.btn-back {
      &:hover {
        transform: translateY(-2px);
      }
    }
  }
}

// ================= クイックワープセクション =================
.quick-nav-section {
  width: 100%;
  text-align: left;

  .section-heading {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.85rem;
    font-weight: 700;
    color: rgba(var(--v-theme-on-surface), 0.65);
    letter-spacing: 0.08em;
    text-transform: uppercase;
    margin-bottom: 14px;
    padding-left: 4px;
  }

  .warp-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 12px;
  }

  .warp-card {
    display: flex;
    align-items: center;
    gap: 14px;
    background: rgba(var(--v-theme-surface), 0.8);
    border: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    border-radius: 12px;
    padding: 14px 16px;
    cursor: pointer;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 3px;
      height: 100%;
      background: transparent;
      transition: background 0.2s ease;
    }

    &:hover {
      background: rgba(var(--v-theme-surface), 1);
      border-color: rgba(var(--v-theme-primary), 0.4);
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);

      &::before {
        background: rgb(var(--v-theme-primary));
      }

      .warp-arrow {
        transform: translateX(3px);
        color: rgb(var(--v-theme-primary));
      }
    }

    .warp-icon {
      width: 44px;
      height: 44px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .warp-info {
      flex: 1;
      min-width: 0;

      .warp-title {
        font-size: 0.95rem;
        font-weight: 700;
        color: rgb(var(--v-theme-on-surface));
        margin-bottom: 2px;
      }

      .warp-desc {
        font-size: 0.75rem;
        color: rgba(var(--v-theme-on-surface), 0.6);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }

    .warp-arrow {
      color: rgba(var(--v-theme-on-surface), 0.35);
      transition: transform 0.2s ease, color 0.2s ease;
    }
  }
}

// ================= レスポンシブ微調整 =================
@media (max-width: 600px) {
  .primary-actions {
    flex-direction: column;
    .action-btn {
      width: 100%;
    }
  }

  .terminal-actions {
    flex-direction: column;
    align-items: stretch;
    .terminal-hint {
      text-align: center;
    }
  }

  .warp-grid {
    grid-template-columns: 1fr;
  }
}
</style>
