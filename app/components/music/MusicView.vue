<template lang="pug">
.music-view-container
  //- ジャンル / フィルターピル (すべて / 歌モノ / インスト / AI楽曲)
  .genre-filter-bar
    v-chip-group(
      v-model="selectedGenre"
      selected-class="text-primary font-weight-bold"
      mandatory
    )
      v-chip(value="all" variant="tonal" size="small") すべて
      v-chip(
        v-for="g in genres"
        :key="g"
        :value="g"
        variant="tonal"
        size="small"
      )
        | {{ g }}
        span.ms-1.text-caption ({{ getGenreCount(g) }})

  //- 1. ジャンル絞り込み時
  .genre-filtered-view(v-if="selectedGenre !== 'all'")
    .genre-header
      v-btn.mb-2(
        prepend-icon="mdi-arrow-left"
        variant="tonal"
        size="small"
        rounded="pill"
        @click="selectedGenre = 'all'"
      ) すべてに戻る
      h2.genre-title {{ selectedGenre }}
      p.genre-subtitle {{ filteredTracks.length }} 曲が見つかりました

    .filtered-grid
      MusicCard(
        v-for="item in filteredTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        showExtra
        @click="openTrack(item)"
        @play="playTrack(item, filteredTracks)"
      )

  //- 2. 「すべて」総合モード（おすすめ / ランダムピックアップ / 歌モノ / AI楽曲 / すべてのジャンルを探索）
  .music-main-scroll(v-else)
    //- ヒーローカルーセル
    MusicHeroBanner(
      :items="featuredTracks"
      @click="openTrack"
      @play="playTrack"
    )

    //- 1. おすすめ
    MusicShelf(
      title="おすすめ"
      subtitle="エノキ電気が贈る厳選トラックコレクション"
    )
      MusicCard(
        v-for="item in recommendedTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, recommendedTracks)"
      )

    //- 2. ランダムピックアップ
    MusicShelf(
      title="ランダムピックアップ"
      subtitle="思いがけない名曲との出会い"
    )
      MusicCard(
        v-for="item in randomPickupTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, randomPickupTracks)"
      )

    //- 3. 歌モノ
    MusicShelf(
      title="歌モノ"
      subtitle="感情豊かなボーカルと心に響くメロディ"
      showMore
      @more="selectedGenre = '歌モノ'"
    )
      MusicCard(
        v-for="item in vocalTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, vocalTracks)"
      )

    //- 4. AI楽曲
    MusicShelf(
      title="AI楽曲"
      subtitle="最先端AI技術と音楽が織りなす新体験サウンド"
      showMore
      @more="selectedGenre = 'AI楽曲'"
    )
      MusicCard(
        v-for="item in aiTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, aiTracks)"
      )

    //- 5. すべてのジャンルを探索 (歌モノ / インスト / AI楽曲)
    .genres-browse-section
      h3.section-heading すべてのジャンルを探索
      p.section-sub お好みのジャンルからお気に入りの音楽を見つけよう
      .genres-grid
        .genre-tile(
          v-for="g in genreTiles"
          :key="g.name"
          :style="{ background: g.gradient }"
          v-ripple
          @click="selectedGenre = g.name"
        )
          .tile-content
            span.tile-name {{ g.name }}
            span.tile-desc {{ g.description }}
            span.tile-count {{ getGenreCount(g.name) }} 曲
          v-icon.tile-icon(size="48" color="rgba(255, 255, 255, 0.28)") {{ g.icon }}

    //- ミニプレイヤー用のボトム余白
    .mini-player-spacer(v-if="currentTrack")
</template>

<script lang="ts">
import { useMusicStore, MUSIC_GENRES, type MusicItem } from '@/stores/music'
import MusicCard from '@/components/music/MusicCard.vue'
import MusicShelf from '@/components/music/MusicShelf.vue'
import MusicHeroBanner from '@/components/music/MusicHeroBanner.vue'

export default {
  name: 'MusicView',
  components: {
    MusicCard,
    MusicShelf,
    MusicHeroBanner,
  },
  setup() {
    const musicStore = useMusicStore()
    return { musicStore }
  },
  data() {
    return {
      selectedGenre: 'all',
      randomPickups: [] as MusicItem[],
      genreTiles: [
        {
          name: '歌モノ',
          gradient: 'linear-gradient(135deg, #F43F5E, #FB923C)',
          icon: 'mdi-microphone-variant',
          description: '感情豊かなボーカル曲コレクション',
        },
        {
          name: 'インスト',
          gradient: 'linear-gradient(135deg, #0EA5E9, #3B82F6)',
          icon: 'mdi-piano',
          description: '作業・集中・リラックスのためのBGM',
        },
        {
          name: 'AI楽曲',
          gradient: 'linear-gradient(135deg, #8B5CF6, #A855F7)',
          icon: 'mdi-robot',
          description: '最先端AI技術による新感覚トラック',
        },
      ],
    }
  },
  computed: {
    allTracks(): MusicItem[] {
      return this.musicStore.list
    },
    isPlaying(): boolean {
      return this.musicStore.isPlaying
    },
    currentTrack(): MusicItem | null {
      return this.musicStore.currentTrack
    },
    currentTrackId(): string {
      return this.musicStore.currentTrack?.id || ''
    },
    genres(): string[] {
      return [...MUSIC_GENRES]
    },
    filteredTracks(): MusicItem[] {
      if (this.selectedGenre === 'all') return this.allTracks
      return this.musicStore.byGenre(this.selectedGenre)
    },
    featuredTracks(): MusicItem[] {
      return this.musicStore.featuredTracks.slice(0, 5)
    },
    recommendedTracks(): MusicItem[] {
      return this.musicStore.recommendedTracks
    },
    randomPickupTracks(): MusicItem[] {
      if (this.randomPickups.length > 0) return this.randomPickups
      return this.musicStore.getRandomPickups(10)
    },
    vocalTracks(): MusicItem[] {
      return this.musicStore.vocalTracks
    },
    aiTracks(): MusicItem[] {
      return this.musicStore.aiTracks
    },
  },
  watch: {
    allTracks: {
      immediate: true,
      handler(newList) {
        if (newList && newList.length > 0 && this.randomPickups.length === 0) {
          this.initRandomPickups()
        }
      },
    },
  },
  mounted() {
    this.initRandomPickups()
  },
  methods: {
    initRandomPickups() {
      this.randomPickups = this.musicStore.getRandomPickups(10)
    },
    getGenreCount(genreName: string): number {
      return this.musicStore.genreCounts[genreName] || 0
    },
    playTrack(track: MusicItem, queue?: MusicItem[]) {
      if (this.currentTrackId === track.id) {
        this.musicStore.togglePlay()
      } else {
        this.musicStore.play(track, queue)
      }
    },
    openTrack(track: MusicItem) {
      if (this.currentTrackId !== track.id) {
        this.musicStore.play(track)
      }
      this.$router.push(`/music/${track.id}`)
    },
  },
}
</script>

<style lang="scss" scoped>
.music-view-container {
  display: flex;
  flex-direction: column;
  padding-bottom: 24px;

  .genre-filter-bar {
    padding: 6px 16px;
    background-color: rgb(var(--v-theme-surface));
    position: sticky;
    top: 0;
    z-index: 8;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.05);
  }

  // 1. ジャンル別絞り込み表示
  .genre-filtered-view {
    padding: 16px;

    .genre-header {
      margin-bottom: 16px;

      .genre-title {
        font-size: 22px;
        font-weight: 800;
        margin: 4px 0 0 0;
      }

      .genre-subtitle {
        font-size: 13px;
        color: rgba(var(--v-theme-on-surface), 0.6);
        margin: 2px 0 0 0;
      }
    }

    .filtered-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }
  }

  // 2. 総合ビュー
  .music-main-scroll {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .section-heading {
    font-size: 19px;
    font-weight: 800;
    letter-spacing: -0.3px;
    margin: 0 0 4px 0;
    color: rgb(var(--v-theme-on-surface));
  }

  .section-sub {
    font-size: 12px;
    color: rgba(var(--v-theme-on-surface), 0.6);
    margin: 0;
  }

  // ジャンル探索タイル (3つのジャンル)
  .genres-browse-section {
    padding: 16px;
    margin-top: 8px;
    margin-bottom: 24px;

    .genres-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 14px;
      margin-top: 14px;

      .genre-tile {
        position: relative;
        height: 104px;
        border-radius: 16px;
        padding: 16px;
        color: #ffffff;
        cursor: pointer;
        overflow: hidden;
        box-shadow: 0 4px 14px rgba(0, 0, 0, 0.16);
        transition: transform 0.2s, box-shadow 0.2s;
        display: flex;
        flex-direction: column;
        justify-content: space-between;

        &:hover {
          transform: translateY(-3px);
          box-shadow: 0 6px 20px rgba(0, 0, 0, 0.22);
        }

        .tile-content {
          z-index: 2;

          .tile-name {
            font-size: 18px;
            font-weight: 800;
            display: block;
            line-height: 1.2;
          }

          .tile-desc {
            font-size: 11px;
            opacity: 0.9;
            margin-top: 4px;
            display: block;
          }

          .tile-count {
            font-size: 11px;
            font-weight: 700;
            opacity: 0.8;
            margin-top: 6px;
            display: inline-block;
          }
        }

        .tile-icon {
          position: absolute;
          bottom: -6px;
          right: -6px;
          transform: rotate(12deg);
          z-index: 1;
        }
      }
    }
  }

  .mini-player-spacer {
    height: 64px;
  }
}
</style>
