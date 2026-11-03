import { defineStore } from 'pinia'
import mockMusicData from '../data/music.json'

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
}

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
  }),

  getters: {
    featuredTracks: (state) => state.list.filter(item => item.featured),
    trendingTracks: (state) => state.list.filter(item => item.isTrending),
    topRanked: (state) => [...state.list].sort((a, b) => b.rating - a.rating),
    byGenre: (state) => (genre: string) => state.list.filter(item => item.genre === genre),
    allGenres: (state) => {
      const genres = new Set<string>()
      state.list.forEach(item => {
        if (item.genre) genres.add(item.genre)
      })
      return Array.from(genres)
    },
    isCurrentLiked: (state) => {
      if (!state.currentTrack) return false
      return state.likedSongIds.includes(state.currentTrack.id)
    },
    isLiked: (state) => (id: string) => state.likedSongIds.includes(id),
  },

  actions: {
    loadMockData(force = false) {
      if (force || !this.list || this.list.length === 0) {
        this.list = [...(mockMusicData as MusicItem[])]
      }
    },

    play(track: MusicItem, newQueue?: MusicItem[]) {
      if (newQueue && newQueue.length > 0) {
        this.queue = [...newQueue]
      } else if (!this.queue.some(t => t.id === track.id)) {
        this.queue = [...this.list]
      }

      this.currentTrack = track
      this.currentTime = 0
      this.isPlaying = true

      // シンセサウンドの再生
      startSynth(track.audioPreset || 'citypop', track.bpm || 120)

      // 再生時間タイマーの開始
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
        stopSynth()
        this.stopTimer()
      } else {
        this.isPlaying = true
        startSynth(this.currentTrack.audioPreset || 'citypop', this.currentTrack.bpm || 120)
        this.startTimer()
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
          stopSynth()
          this.stopTimer()
        }
      } else {
        this.play(this.queue[currentIndex + 1])
      }
    },

    prev() {
      if (!this.currentTrack || this.queue.length === 0) return

      // 再生開始3秒以降なら曲の先頭に戻る
      if (this.currentTime > 3) {
        this.currentTime = 0
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
      this.currentTime = Math.max(0, Math.min(time, this.currentTrack?.duration || 180))
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
      if (masterGain && audioCtx) {
        masterGain.gain.setValueAtTime(this.isMuted ? 0 : this.volume * 0.4, audioCtx.currentTime)
      }
    },

    toggleMute() {
      this.isMuted = !this.isMuted
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
