import { defineStore } from 'pinia'
import mockMusicData from '../data/music.json'
import { fetchMusicList } from '@/js/contentApi'

/**
 * 音楽ジャンル定数（「歌モノ」「インスト」「AI楽曲」の3つ）
 */

/**
 * 楽曲が「未完成」であるかを判定するヘルパー関数
 */
export function isTrackUnfinished(
  track: { isUnfinished?: boolean; tags?: string[] } | null | undefined,
): boolean {
  if (!track) return false
  if (track.isUnfinished === true) return true
  if (
    Array.isArray(track.tags) &&
    track.tags.some(
      (t) =>
        typeof t === 'string' &&
        (t.trim() === '未完成' ||
          t.trim().toLowerCase() === 'wip' ||
          t.trim().toLowerCase() === 'unfinished'),
    )
  ) {
    return true
  }
  return false
}

export const MUSIC_GENRES = ['歌モノ', 'インスト', 'AI楽曲'] as const
export type MusicGenre = (typeof MUSIC_GENRES)[number]

export interface MusicItem {
  id: string
  name: string
  title: string
  artist: string
  album: string
  albumType: 'single' | 'album' | 'ep'
  genre: string
  cover: string
  icon: string
  thumbnail: string
  duration: number
  durationFormatted: string
  releaseDate: number
  releaseDateFormatted: string
  plays: string
  rating: number
  featured: boolean
  isTrending: boolean
  themeColor: string
  accentColor: string
  audioPreset: string
  bpm: number
  description: string
  lyrics: string
  composer: string
  lyricist: string
  price: number
  type: string
  audioUrl?: string
  isUnfinished?: boolean
  tags?: string[]
}

// 実際の音声ファイル再生用（mp3 / wav 等）
let audioElement: HTMLAudioElement | null = null
/** audioElement が読み込んでいる楽曲のID */
let audioTrackId: string | null = null

// Web Audio API によるシンセプレビューエンジン（簡易シンセサイザー）
let audioCtx: AudioContext | null = null
let synthInterval: number | null = null
let masterGain: GainNode | null = null

// 音階の周波数テーブル (Hz)
const NOTES: Record<string, number> = {
  C3: 130.81, D3: 146.83, E3: 164.81, F3: 174.61, G3: 196.00, A3: 220.00, B3: 246.94,
  C4: 261.63, D4: 293.66, E4: 329.63, F4: 349.23, G4: 392.00, A4: 440.00, B4: 493.88,
  C5: 523.25, D5: 587.33, E5: 659.25, F5: 698.46, G5: 783.99, A5: 880.00, B5: 987.77,
}

// プリセットごとのコード進行＆メロディ
const PRESETS: Record<string, { wave: OscillatorType; chords: string[][]; filterFreq: number }> = {
  lofi: {
    wave: 'triangle',
    chords: [
      ['C4', 'E4', 'G4', 'B4'],
      ['A3', 'C4', 'E4', 'G4'],
      ['D4', 'F4', 'A4', 'C5'],
      ['G3', 'B3', 'D4', 'F4'],
    ],
    filterFreq: 1200,
  },
  citypop: {
    wave: 'sawtooth',
    chords: [
      ['F4', 'A4', 'C5', 'E5'],
      ['E4', 'G4', 'B4', 'D5'],
      ['D4', 'F4', 'A4', 'C5'],
      ['C4', 'E4', 'G4', 'B4'],
    ],
    filterFreq: 2400,
  },
  synthwave: {
    wave: 'sawtooth',
    chords: [
      ['A3', 'C4', 'E4', 'A4'],
      ['F3', 'A3', 'C4', 'F4'],
      ['C4', 'E4', 'G4', 'C5'],
      ['G3', 'B3', 'D4', 'G4'],
    ],
    filterFreq: 3200,
  },
  piano: {
    wave: 'sine',
    chords: [
      ['C4', 'E4', 'G4', 'C5'],
      ['G3', 'B3', 'D4', 'G4'],
      ['A3', 'C4', 'E4', 'A4'],
      ['F3', 'A3', 'C4', 'F4'],
    ],
    filterFreq: 3800,
  },
  edm: {
    wave: 'sawtooth',
    chords: [
      ['D4', 'F4', 'A4', 'D5'],
      ['B3', 'D4', 'F4', 'B4'],
      ['G3', 'B3', 'D4', 'G4'],
      ['A3', 'C4', 'E4', 'A4'],
    ],
    filterFreq: 4000,
  },
  acoustic: {
    wave: 'triangle',
    chords: [
      ['G3', 'B3', 'D4', 'G4'],
      ['D4', 'F4', 'A4', 'D5'],
      ['E4', 'G4', 'B4', 'E5'],
      ['C4', 'E4', 'G4', 'C5'],
    ],
    filterFreq: 2800,
  },
  ambient: {
    wave: 'sine',
    chords: [
      ['E3', 'B3', 'E4', 'G4'],
      ['C3', 'G3', 'C4', 'E4'],
      ['D3', 'A3', 'D4', 'F4'],
      ['B2', 'F3', 'B3', 'D4'],
    ],
    filterFreq: 900,
  },
}

function initAudioContext() {
  if (typeof window === 'undefined') return null
  if (!audioCtx) {
    const AudioCtxClass = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext
    if (AudioCtxClass) {
      audioCtx = new AudioCtxClass()
      masterGain = audioCtx.createGain()
      masterGain.gain.setValueAtTime(0.3, audioCtx.currentTime)
      masterGain.connect(audioCtx.destination)
    }
  }
  if (audioCtx && audioCtx.state === 'suspended') {
    audioCtx.resume()
  }
  return audioCtx
}

function stopSynth() {
  if (synthInterval !== null) {
    clearInterval(synthInterval)
    synthInterval = null
  }
}

function startSynth(presetName: string, bpm: number) {
  stopSynth()
  const ctx = initAudioContext()
  if (!ctx || !masterGain) return

  const preset = PRESETS[presetName] || PRESETS.lofi
  const intervalMs = (60 / bpm) * 500 // 8分音符の間隔

  let chordIndex = 0
  let noteIndex = 0

  synthInterval = window.setInterval(() => {
    if (!ctx || ctx.state === 'suspended') return

    const currentChord = preset.chords[chordIndex]
    const noteName = currentChord[noteIndex % currentChord.length]
    const freq = NOTES[noteName] || 440

    // オシレーター生成
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    const filter = ctx.createBiquadFilter()

    osc.type = preset.wave
    osc.frequency.setValueAtTime(freq, ctx.currentTime)

    filter.type = 'lowpass'
    filter.frequency.setValueAtTime(preset.filterFreq, ctx.currentTime)

    // エンベロープ
    const now = ctx.currentTime
    gain.gain.setValueAtTime(0, now)
    gain.gain.linearRampToValueAtTime(0.18, now + 0.04)
    gain.gain.exponentialRampToValueAtTime(0.001, now + (intervalMs / 1000) * 1.5)

    osc.connect(filter)
    filter.connect(gain)
    gain.connect(masterGain!)

    osc.start(now)
    osc.stop(now + (intervalMs / 1000) * 1.6)

    noteIndex++
    if (noteIndex >= 4) {
      noteIndex = 0
      chordIndex = (chordIndex + 1) % preset.chords.length
    }
  }, intervalMs)
}

export const useMusicStore = defineStore('music', {
  state: () => ({
    list: [...(mockMusicData as MusicItem[])] as MusicItem[],
    /** データベース (MySQL) から読み込み中か */
    dbLoading: false,
    /** データベースから一度でも読み込めたか */
    dbLoaded: false,
    /** 最後に発生した読み込みエラー */
    dbError: null as string | null,
    currentTrack: null as MusicItem | null,
    isPlaying: false,
    currentTime: 0,
    volume: 0.8,
    isMuted: false,
    shuffle: false,
    repeat: 'all' as 'off' | 'all' | 'one',
    likedSongIds: ['music-001', 'music-004', 'music-007', 'music-012', 'music-020'] as string[],
    queue: [] as MusicItem[],
    nowPlayingModalOpen: false,
    playbackTimer: null as number | null,
    /** 音声ファイルの再生に失敗したときのメッセージ */
    playError: null as string | null,
  }),

  getters: {
    featuredTracks: (state) => state.list.filter(item => item.featured),
    trendingTracks: (state) => state.list.filter(item => item.isTrending),
    recommendedTracks: (state) => {
      const featured = state.list.filter(item => item.featured)
      const others = state.list.filter(item => !item.featured)
      return [...featured, ...others].slice(0, 10)
    },
    vocalTracks: (state) => state.list.filter(item => item.genre === '歌モノ'),
    instrumentalTracks: (state) => state.list.filter(item => item.genre === 'インスト'),
    aiTracks: (state) => state.list.filter(item => item.genre === 'AI楽曲'),
    topRanked: (state) => [...state.list].sort((a, b) => b.rating - a.rating),
    byGenre: (state) => (genre: string) => state.list.filter(item => item.genre === genre),
    allGenres: (): string[] => [...MUSIC_GENRES],
    genreCounts: (state) => {
      const counts: Record<string, number> = {}
      for (const g of MUSIC_GENRES) {
        counts[g] = state.list.filter(item => item.genre === g).length
      }
      return counts
    },
    isCurrentLiked: (state) => {
      if (!state.currentTrack) return false
      return state.likedSongIds.includes(state.currentTrack.id)
    },
    isLiked: (state) => (id: string) => state.likedSongIds.includes(id),
  },

  actions: {
    /**
     * PHP 経由で MySQL (music_list) から楽曲一覧を読み込み、リストを置き換える
     * 失敗した場合は現在のリストを維持（空ならモックデータを表示）
     * @returns 読み込みに成功したら true
     */
    async fetchFromDatabase(): Promise<boolean> {
      this.dbLoading = true
      try {
        const list = await fetchMusicList<MusicItem>()
        this.list = list
        // 再生中の曲がDBで更新・削除されていたら反映
        if (this.currentTrack) {
          const latest = list.find(t => t.id === this.currentTrack?.id)
          if (latest) this.currentTrack = latest
        }
        this.queue = this.queue.filter(q => list.some(t => t.id === q.id))
        this.dbLoaded = true
        this.dbError = null
        return true
      } catch (err: any) {
        this.dbError = err?.message || String(err)
        console.warn('楽曲一覧のDB読み込みに失敗しました:', this.dbError)
        if (!this.list || this.list.length === 0) {
          this.loadMockData(true)
        }
        return false
      } finally {
        this.dbLoading = false
      }
    },

    getRandomPickups(count = 10): MusicItem[] {
      if (!this.list || this.list.length === 0) return []
      const shuffled = [...this.list].sort(() => Math.random() - 0.5)
      return shuffled.slice(0, count)
    },

    loadMockData(force = false) {
      const needsRefresh =
        !this.list ||
        this.list.length === 0 ||
        !this.list.some(item => item.genre === '歌モノ')
      if (force || needsRefresh) {
        this.list = [...(mockMusicData as MusicItem[])]
      }
    },

    /**
     * 新しい楽曲を登録してリストの先頭に追加（既存IDなら更新）
     */
    addTrack(track: MusicItem) {
      const existingIdx = this.list.findIndex(t => t.id === track.id)
      if (existingIdx !== -1) {
        this.list[existingIdx] = track
      } else {
        this.list.unshift(track)
      }
    },

    /**
     * 楽曲を更新
     */
    updateTrack(track: MusicItem) {
      this.addTrack(track)
      if (this.currentTrack && this.currentTrack.id === track.id) {
        this.currentTrack = track
      }
    },

    /**
     * 楽曲を削除
     */
    removeTrack(id: string) {
      if (this.currentTrack && this.currentTrack.id === id) {
        this.stopAudio()
        this.currentTrack = null
      }
      const idx = this.list.findIndex(t => t.id === id)
      if (idx !== -1) {
        this.list.splice(idx, 1)
      }
      this.queue = this.queue.filter(t => t.id !== id)
    },

    /**
     * 現在再生中の音声を停止
     */
    stopAudio() {
      stopSynth()
      if (audioElement) {
        audioElement.pause()
        audioElement.currentTime = 0
        audioElement.removeAttribute('src')
        audioElement.load()
        audioElement = null
      }
      audioTrackId = null
      this.stopTimer()
    },

    play(track: MusicItem, newQueue?: MusicItem[], startAt = 0) {
      if (newQueue && newQueue.length > 0) {
        this.queue = [...newQueue]
      } else if (!this.queue.some(t => t.id === track.id)) {
        this.queue = [...this.list]
      }

      this.stopAudio()

      // DBから読み込んだ最新データを優先（古いモックデータで再生しないように）
      const latest = this.list.find(t => t.id === track.id)
      if (latest) track = latest

      this.currentTrack = track
      this.currentTime = startAt
      this.isPlaying = true
      this.playError = null

      // 実際の音声ファイル (mp3 / wav 等) がある場合は HTMLAudioElement で再生
      // ※ 失敗してもデモ用シンセには切り替えない（アップロードした曲が鳴らない原因を隠してしまうため）
      if (track.audioUrl) {
        if (typeof window === 'undefined') return
        const audio = new Audio(track.audioUrl)
        audioElement = audio
        audioTrackId = track.id
        audio.preload = 'auto'
        audio.volume = this.isMuted ? 0 : this.volume
        if (startAt > 0) audio.currentTime = startAt

        const fail = (reason: string) => {
          if (audioElement !== audio) return
          console.warn(`音声ファイルを再生できませんでした (${track.audioUrl}):`, reason)
          this.playError = '音声ファイルを再生できませんでした'
          this.isPlaying = false
        }

        audio.ontimeupdate = () => {
          if (audioElement === audio) {
            this.currentTime = Math.floor(audio.currentTime)
          }
        }

        audio.onloadedmetadata = () => {
          if (audioElement === audio && this.currentTrack && audio.duration && !isNaN(audio.duration)) {
            this.currentTrack.duration = Math.floor(audio.duration)
            const mins = Math.floor(audio.duration / 60)
            const secs = Math.floor(audio.duration % 60)
            this.currentTrack.durationFormatted = `${mins}:${secs < 10 ? '0' : ''}${secs}`
          }
        }

        audio.onerror = () => {
          const code = audio.error?.code
          fail(`MediaError code ${code ?? 'unknown'}`)
        }

        audio.onended = () => {
          if (audioElement === audio) this.next()
        }

        audio.play().catch((err) => {
          // 自動再生ブロック等。onerror 側で拾えないケースのみ扱う
          if (err?.name === 'AbortError') return
          fail(String(err?.message || err))
        })
        return
      }

      // 音声ファイルが未登録の曲のみ、デモ用シンセサイザーで再生
      startSynth(track.audioPreset || 'citypop', track.bpm || 120)
      this.startTimer()
    },

    togglePlay() {
      if (!this.currentTrack) {
        if (this.list.length > 0) {
          this.play(this.list[0])
        }
        return
      }

      if (this.isPlaying) {
        this.isPlaying = false
        if (audioElement) {
          audioElement.pause()
        } else {
          stopSynth()
        }
        this.stopTimer()
      } else {
        // まだ音声が読み込まれていない（曲を選択しただけ / 別の曲の音声が残っている）場合は、
        // その曲の音声ファイルを読み込んで再生する
        if (this.currentTrack.audioUrl && (!audioElement || audioTrackId !== this.currentTrack.id)) {
          this.play(this.currentTrack, undefined, this.currentTime)
          return
        }
        this.isPlaying = true
        if (audioElement) {
          audioElement.play().catch((err) => {
            console.warn('Audio resume failed:', err)
            this.playError = '音声ファイルを再生できませんでした'
            this.isPlaying = false
          })
        } else {
          startSynth(this.currentTrack.audioPreset || 'citypop', this.currentTrack.bpm || 120)
          this.startTimer()
        }
      }
    },

    next() {
      if (!this.currentTrack || this.queue.length === 0) return

      if (this.repeat === 'one') {
        this.currentTime = 0
        this.play(this.currentTrack)
        return
      }

      if (this.shuffle) {
        const randomIndex = Math.floor(Math.random() * this.queue.length)
        this.play(this.queue[randomIndex])
        return
      }

      const currentIndex = this.queue.findIndex(t => t.id === this.currentTrack!.id)
      if (currentIndex === -1 || currentIndex === this.queue.length - 1) {
        if (this.repeat === 'all') {
          this.play(this.queue[0])
        } else {
          this.isPlaying = false
          this.stopAudio()
        }
      } else {
        this.play(this.queue[currentIndex + 1])
      }
    },

    prev() {
      if (!this.currentTrack || this.queue.length === 0) return

      // 再生開始3秒以降なら曲の先頭に戻る
      if (this.currentTime > 3) {
        this.seek(0)
        return
      }

      const currentIndex = this.queue.findIndex(t => t.id === this.currentTrack!.id)
      if (currentIndex <= 0) {
        this.play(this.queue[this.queue.length - 1])
      } else {
        this.play(this.queue[currentIndex - 1])
      }
    },

    seek(time: number) {
      const maxDuration = this.currentTrack?.duration || 180
      this.currentTime = Math.max(0, Math.min(time, maxDuration))
      if (audioElement) {
        audioElement.currentTime = this.currentTime
      }
    },

    toggleLike(id: string) {
      const idx = this.likedSongIds.indexOf(id)
      if (idx === -1) {
        this.likedSongIds.push(id)
      } else {
        this.likedSongIds.splice(idx, 1)
      }
    },

    toggleShuffle() {
      this.shuffle = !this.shuffle
    },

    toggleRepeat() {
      if (this.repeat === 'off') this.repeat = 'all'
      else if (this.repeat === 'all') this.repeat = 'one'
      else this.repeat = 'off'
    },

    setVolume(vol: number) {
      this.volume = Math.max(0, Math.min(1, vol))
      if (audioElement) {
        audioElement.volume = this.isMuted ? 0 : this.volume
      }
      if (masterGain && audioCtx) {
        masterGain.gain.setValueAtTime(this.isMuted ? 0 : this.volume * 0.4, audioCtx.currentTime)
      }
    },

    toggleMute() {
      this.isMuted = !this.isMuted
      if (audioElement) {
        audioElement.volume = this.isMuted ? 0 : this.volume
      }
      if (masterGain && audioCtx) {
        masterGain.gain.setValueAtTime(this.isMuted ? 0 : this.volume * 0.4, audioCtx.currentTime)
      }
    },

    openNowPlaying() {
      this.nowPlayingModalOpen = true
    },

    closeNowPlaying() {
      this.nowPlayingModalOpen = false
    },

    startTimer() {
      this.stopTimer()
      this.playbackTimer = window.setInterval(() => {
        if (!this.isPlaying || !this.currentTrack) return
        this.currentTime += 1
        if (this.currentTime >= this.currentTrack.duration) {
          this.next()
        }
      }, 1000)
    },

    stopTimer() {
      if (this.playbackTimer !== null) {
        clearInterval(this.playbackTimer)
        this.playbackTimer = null
      }
    },
  },

  persist: true,
})
