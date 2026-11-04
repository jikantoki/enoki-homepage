<template lang="pug">
.music-view-container
  //- ジャンル / フィルターピル
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
      ) {{ g }}

  //- 1. ジャンル絞り込み時
  .genre-filtered-view(v-if="selectedGenre !== 'all'")
    .genre-header
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

  //- 2. 「すべて」総合モード (Spotify / Apple Music フル体験)
  .music-main-scroll(v-else)
    //- ヒーロー大型カルーセル
    MusicHeroBanner(
      :items="featuredTracks"
      @click="openTrack"
      @play="playTrack"
    )

    //- Spotify風 クイックアクセス (6グリッド)
    .quick-picks-section
      h3.section-heading おすすめのピックアップ
      .quick-grid
        .quick-card(
          v-for="item in quickPicks"
          :key="item.id"
          :class="{ 'is-active': currentTrackId === item.id }"
          v-ripple
          @click="playTrack(item)"
        )
          img.quick-thumb(:src="item.cover || item.icon")
          .quick-text
            span.quick-title {{ item.title }}
          .quick-play-btn
            v-btn(
              icon
              color="primary"
              size="x-small"
              elevation="3"
            )
              v-icon(:icon="currentTrackId === item.id && isPlaying ? 'mdi-pause' : 'mdi-play'" size="16" color="white")

    //- Shelf: 話題のトレンド曲
    MusicShelf(
      title="🔥 トレンド急上昇"
      subtitle="今もっとも聴かれている人気トラック"
      showMore
      @more="selectedGenre = 'J-POP'"
    )
      MusicCard(
        v-for="item in trendingTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, trendingTracks)"
      )

    //- ランキング: Top 10 トラックリスト
    .ranking-section
      .ranking-header
        .title-area
          h3.section-heading 🏆 ENOKI TOP 10
          p.section-sub リアルタイム総合ヒットチャート
      .ranking-track-list
        MusicTrackRow(
          v-for="(item, idx) in topRankedTracks"
          :key="item.id"
          :item="item"
          :rank="idx + 1"
          :isPlaying="isPlaying"
          :currentTrackId="currentTrackId"
          :isLiked="musicStore.isLiked(item.id)"
          @click="openTrack(item)"
          @play="playTrack(item, topRankedTracks)"
          @like="musicStore.toggleLike($event)"
        )

    //- Shelf: Lo-Fi & チルビート (作業用BGM)
    MusicShelf(
      title="☕ 深夜の作業用 Lo-Fi Beats"
      subtitle="集中・リラックス・読書のためのチルサウンド"
      showMore
      @more="selectedGenre = 'Lo-Fi'"
    )
      MusicCard(
        v-for="item in lofiTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, lofiTracks)"
      )

    //- Shelf: シティポップ & ネオンレトロ
    MusicShelf(
      title="🌆 煌めく City Pop & Synthwave"
      subtitle="80sグルーヴとレトロフューチャー"
      showMore
      @more="selectedGenre = 'City Pop'"
    )
      MusicCard(
        v-for="item in cityPopTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, cityPopTracks)"
      )

    //- Shelf: アニメ＆ゲーム サウンドトラック
    MusicShelf(
      title="⚔️ アニメ＆ゲーム テーマソング"
      subtitle="胸が熱くなる壮大なメロディと主題歌"
      showMore
      @more="selectedGenre = 'Anime/Game'"
    )
      MusicCard(
        v-for="item in animeTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, animeTracks)"
      )

    //- Shelf: エレクトロニック & ダンス
    MusicShelf(
      title="⚡ ハイエナジー EDM & Club"
      subtitle="高揚感を刺激するフロアアンセム"
      showMore
      @more="selectedGenre = 'EDM'"
    )
      MusicCard(
        v-for="item in edmTracks"
        :key="item.id"
        :item="item"
        :isPlaying="isPlaying"
        :currentTrackId="currentTrackId"
        @click="openTrack(item)"
        @play="playTrack(item, edmTracks)"
      )

    //- Spotify風 ジャンル一覧タイル
    .genres-browse-section
      h3.section-heading すべてのジャンルを探索
      .genres-grid
        .genre-tile(
          v-for="g in genreTiles"
          :key="g.name"
          :style="{ background: g.gradient }"
          v-ripple
          @click="selectedGenre = g.name"
        )
          span.tile-name {{ g.name }}
          v-icon.tile-icon(size="36" color="rgba(255, 255, 255, 0.3)") {{ g.icon }}

    //- ミニプレイヤー用のボトム余白
    .mini-player-spacer(v-if="currentTrack")
</template>

<script lang="ts">
import { useMusicStore, type MusicItem } from '@/stores/music'
import MusicCard from '@/components/music/MusicCard.vue'
import MusicTrackRow from '@/components/music/MusicTrackRow.vue'
import MusicShelf from '@/components/music/MusicShelf.vue'
import MusicHeroBanner from '@/components/music/MusicHeroBanner.vue'

export default {
  name: 'MusicView',
  components: {
    MusicCard,
    MusicTrackRow,
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
      genreTiles: [
        { name: 'J-POP', gradient: 'linear-gradient(135deg, #F43F5E, #FB923C)', icon: 'mdi-music' },
        { name: 'City Pop', gradient: 'linear-gradient(135deg, #4338CA, #38BDF8)', icon: 'mdi-weather-night' },
        { name: 'Lo-Fi', gradient: 'linear-gradient(135deg, #78350F, #D97706)', icon: 'mdi-coffee' },
        { name: 'Synthwave', gradient: 'linear-gradient(135deg, #831843, #06B6D4)', icon: 'mdi-lightning-bolt' },
        { name: 'Anime/Game', gradient: 'linear-gradient(135deg, #1E3A8A, #3B82F6)', icon: 'mdi-sword' },
        { name: 'EDM', gradient: 'linear-gradient(135deg, #047857, #10B981)', icon: 'mdi-speaker' },
        { name: 'Piano', gradient: 'linear-gradient(135deg, #1E293B, #64748B)', icon: 'mdi-piano' },
        { name: 'Acoustic', gradient: 'linear-gradient(135deg, #713F12, #EAB308)', icon: 'mdi-guitar-acoustic' },
        { name: 'Rock', gradient: 'linear-gradient(135deg, #881337, #E11D48)', icon: 'mdi-guitar-electric' },
        { name: 'R&B', gradient: 'linear-gradient(135deg, #312E81, #A855F7)', icon: 'mdi-heart-pulse' },
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
      return this.musicStore.allGenres
    },
    filteredTracks(): MusicItem[] {
      if (this.selectedGenre === 'all') return this.allTracks
      return this.musicStore.byGenre(this.selectedGenre)
    },
    featuredTracks(): MusicItem[] {
      return this.musicStore.featuredTracks.slice(0, 5)
    },
    quickPicks(): MusicItem[] {
      return this.allTracks.slice(0, 6)
    },
    trendingTracks(): MusicItem[] {
      return this.allTracks.filter(t => t.isTrending).slice(0, 10)
    },
    topRankedTracks(): MusicItem[] {
      return this.musicStore.topRanked.slice(0, 10)
    },
    lofiTracks(): MusicItem[] {
      return this.allTracks.filter(t => t.genre === 'Lo-Fi' || t.genre === 'Ambient').slice(0, 10)
    },
    cityPopTracks(): MusicItem[] {
      return this.allTracks.filter(t => t.genre === 'City Pop' || t.genre === 'Synthwave').slice(0, 10)
    },
    animeTracks(): MusicItem[] {
      return this.allTracks.filter(t => t.genre === 'Anime/Game').slice(0, 10)
    },
    edmTracks(): MusicItem[] {
      return this.allTracks.filter(t => t.genre === 'EDM').slice(0, 10)
    },
  },
  methods: {
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
  }

  // 1. ジャンル別絞り込み表示
  .genre-filtered-view {
    padding: 16px;

    .genre-header {
      margin-bottom: 16px;

      .genre-title {
        font-size: 22px;
        font-weight: 800;
        margin: 0;
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

  // Spotify風 6グリッド クイックアクセス
  .quick-picks-section {
    padding: 16px;

    .quick-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 10px;
      margin-top: 12px;

      @media (min-width: 768px) {
        grid-template-columns: repeat(3, 1fr);
      }

      .quick-card {
        display: flex;
        align-items: center;
        background-color: rgba(var(--v-theme-on-surface), 0.05);
        border-radius: 8px;
        overflow: hidden;
        cursor: pointer;
        transition: background-color 0.2s, transform 0.15s;
        height: 54px;
        position: relative;

        &:hover {
          background-color: rgba(var(--v-theme-on-surface), 0.1);
          transform: translateY(-1px);

          .quick-play-btn {
            opacity: 1;
            transform: scale(1);
          }
        }

        &.is-active {
          background-color: rgba(var(--v-theme-primary), 0.12);
          .quick-title {
            color: rgb(var(--v-theme-primary));
          }
        }

        .quick-thumb {
          width: 54px;
          height: 54px;
          object-fit: cover;
          flex-shrink: 0;
        }

        .quick-text {
          flex: 1;
          padding: 0 10px;
          min-width: 0;

          .quick-title {
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
          }
        }

        .quick-play-btn {
          position: absolute;
          right: 8px;
          opacity: 0;
          transform: scale(0.85);
          transition: opacity 0.2s, transform 0.2s;
        }
      }
    }
  }

  // ランキングセクション
  .ranking-section {
    padding: 16px;
    margin-bottom: 24px;

    .ranking-header {
      margin-bottom: 12px;
    }

    .ranking-track-list {
      display: flex;
      flex-direction: column;
      gap: 4px;
      background: rgba(var(--v-theme-on-surface), 0.02);
      border-radius: 12px;
      padding: 6px;
    }
  }

  // ジャンル探索タイル
  .genres-browse-section {
    padding: 16px;
    margin-bottom: 24px;

    .genres-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
      margin-top: 12px;

      @media (min-width: 600px) {
        grid-template-columns: repeat(4, 1fr);
      }

      .genre-tile {
        position: relative;
        height: 84px;
        border-radius: 12px;
        padding: 14px;
        color: #ffffff;
        cursor: pointer;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transition: transform 0.2s;

        &:hover {
          transform: translateY(-3px);
        }

        .tile-name {
          font-size: 16px;
          font-weight: 800;
          display: block;
        }

        .tile-icon {
          position: absolute;
          bottom: -4px;
          right: -4px;
          transform: rotate(15deg);
        }
      }
    }
  }

  .mini-player-spacer {
    height: 64px;
  }
}
</style>
