-- ========================================================
-- アプリ画像 Base64 -> 公開URL 移行 SQL
-- 生成日時: 2026-11-10 10:32:20
-- 更新件数: 40 件
-- ========================================================

START TRANSACTION;

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_enoden-news_1_1794306738_545f9d78.jpg\"]', `icon` = '/uploads/images/img_1794242795269_xvd5z0af.png', `thumbnail` = '/uploads/images/img_1794242799706_onzfo96s.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'enoden-news';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_homepage_1_1794306739_708579ee.png\"]', `icon` = '/uploads/images/img_1794243150873_7ai55o29.png', `thumbnail` = '/uploads/images/img_1794243153857_xen4g26b.png', `updatedAt` = 1794306738 WHERE `appId` = 'homepage';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_lednews_1_1794306739_c286616c.jpg\"]', `icon` = '/uploads/images/img_1794243182386_1yk8vt6i.jpg', `thumbnail` = '/uploads/images/img_1794243188122_ng8k5fkm.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'lednews';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_enokiosk_1_1794306739_c0367797.svg\"]', `icon` = '/uploads/images/img_1794243077791_r3abk27g.jpg', `thumbnail` = '/uploads/images/img_1794243081852_l1evmgio.svg', `updatedAt` = 1794306738 WHERE `appId` = 'enokiosk';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_joa_1_1794306739_e515126b.svg\"]', `icon` = '/uploads/images/img_1794243056747_oyrik21u.jpg', `thumbnail` = '/uploads/images/img_1794243060777_plkpz4bi.svg', `updatedAt` = 1794306738 WHERE `appId` = 'joa';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_japan-hidden-wiki_1_1794306739_250fa269.svg\"]', `icon` = '/uploads/images/img_1794243036144_nwqfjvy6.jpg', `thumbnail` = '/uploads/images/img_1794243040331_klwkfv6i.svg', `updatedAt` = 1794306738 WHERE `appId` = 'japan-hidden-wiki';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_map-studio_1_1794306739_73db23a6.webp\"]', `icon` = '/uploads/images/img_1794242745989_rke6ewn1.png', `thumbnail` = '/uploads/images/img_1794242750414_uh16dnzd.webp', `updatedAt` = 1794306738 WHERE `appId` = 'map-studio';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_wallet-wallet_1_1794306739_a6350e6c.webp\"]', `icon` = '/uploads/images/img_1794242724031_14qwapln.webp', `thumbnail` = '/uploads/images/img_1794242727416_t4ogprtq.webp', `updatedAt` = 1794306738 WHERE `appId` = 'wallet-wallet';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_nomad-pulse_1_1794306739_48646a90.svg\"]', `icon` = '/uploads/images/img_1794242704003_ee8xaswg.png', `thumbnail` = '/uploads/images/img_1794242709637_dmwryk59.svg', `updatedAt` = 1794306738 WHERE `appId` = 'nomad-pulse';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_keiban_1_1794306739_0f007af9.jpg\"]', `icon` = '/uploads/images/img_1794242682575_rkqrwns2.webp', `thumbnail` = '/uploads/images/img_1794242685532_uqwv8jmp.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'keiban';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_vuetube_1_1794306739_2dde9a50.svg\"]', `icon` = '/uploads/images/img_1794242662835_jzizxtwq.webp', `thumbnail` = '/uploads/images/img_1794242667608_r66xyzyx.svg', `updatedAt` = 1794306738 WHERE `appId` = 'vuetube';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_wp-viewer_1_1794306739_e52301d2.svg\"]', `icon` = '/uploads/images/img_1794242630893_m4oek1nl.png', `thumbnail` = '/uploads/images/img_1794242643346_ce3gv6ve.svg', `updatedAt` = 1794306738 WHERE `appId` = 'wp-viewer';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_nuxt4-template_1_1794306739_4351864b.svg\"]', `icon` = '/uploads/images/img_1794242991823_iety903z.svg', `thumbnail` = '/uploads/images/img_1794242991831_7c8z2w1o.svg', `updatedAt` = 1794306738 WHERE `appId` = 'nuxt4-template';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_jikantoki-music-player_1_1794306739_cd7918fa.svg\"]', `icon` = '/uploads/images/img_1794242614537_hpnvxqqs.webp', `thumbnail` = '/uploads/images/img_1794242618865_98xcg1nr.svg', `updatedAt` = 1794306738 WHERE `appId` = 'jikantoki-music-player';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_jump-server_1_1794306739_44cc8950.svg\"]', `icon` = '/uploads/images/img_1794242977501_hfbwy1ey.svg', `thumbnail` = '/uploads/images/img_1794242977507_5kl582nw.svg', `updatedAt` = 1794306738 WHERE `appId` = 'jump-server';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_mdsns_1_1794306739_4aac5c8f.svg\"]', `icon` = '/uploads/images/img_1794242961781_gwtssd7v.svg', `thumbnail` = '/uploads/images/img_1794242961798_5ynw9a5c.svg', `updatedAt` = 1794306738 WHERE `appId` = 'mdsns';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_dopamine_1_1794306739_6907ee9b.svg\"]', `icon` = '/uploads/images/img_1794242596736_zzq29u2f.png', `thumbnail` = '/uploads/images/img_1794242601291_aiqeob9y.svg', `updatedAt` = 1794306738 WHERE `appId` = 'dopamine';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_youtube-downloader_1_1794306739_401e8a14.svg\"]', `icon` = '/uploads/images/img_1794242946551_mjmztsbk.svg', `thumbnail` = '/uploads/images/img_1794242946557_xbiqidb5.svg', `updatedAt` = 1794306738 WHERE `appId` = 'youtube-downloader';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_vue-android-app-template_1_1794306739_17701af1.svg\"]', `icon` = '/uploads/images/img_1794242558499_r87dd59x.svg', `thumbnail` = '/uploads/images/img_1794242558514_cx7jrlwr.svg', `updatedAt` = 1794306738 WHERE `appId` = 'vue-android-app-template';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_super3_1_1794306739_9f766b1d.png\"]', `icon` = '/uploads/images/img_1794242372282_2twpc2ur.png', `thumbnail` = '/uploads/images/img_1794242423628_afkrmsrk.png', `updatedAt` = 1794306738 WHERE `appId` = 'super3';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_yukkuri-monogatari_1_1794306739_b85ae225.svg\"]', `icon` = '/uploads/images/img_1794242352299_aiypgobx.jpg', `thumbnail` = '/uploads/images/img_1794242356291_8cy5twhp.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'yukkuri-monogatari';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_raspberry-pi-car-audio_1_1794306739_82fd5ce9.svg\"]', `icon` = '/uploads/images/img_1794242534505_z350ewc2.svg', `thumbnail` = '/uploads/images/img_1794242534537_ma0ktfwy.svg', `updatedAt` = 1794306738 WHERE `appId` = 'raspberry-pi-car-audio';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_twitter-no-spam_1_1794306739_eadfedb6.svg\"]', `icon` = '/uploads/images/img_1794242308308_8txzwgeh.png', `thumbnail` = '/uploads/images/img_1794242315807_onrgevk6.svg', `updatedAt` = 1794306738 WHERE `appId` = 'twitter-no-spam';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_css-muda_1_1794306739_213310c7.svg\"]', `icon` = '/uploads/images/img_1794242919624_8djpn3vv.jpg', `thumbnail` = '/uploads/images/img_1794242921057_0ew0f8by.svg', `updatedAt` = 1794306738 WHERE `appId` = 'css-muda';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_pachi-simulator_1_1794306739_f0e44827.svg\"]', `icon` = '/uploads/images/img_1794242225650_l5qx88fb.svg', `thumbnail` = '/uploads/images/img_1794242225658_abnm8crt.svg', `updatedAt` = 1794306738 WHERE `appId` = 'pachi-simulator';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_nichiji-koushin_1_1794306739_e78aad8c.svg\"]', `icon` = '/uploads/images/img_1794242207828_eja5k7p9.png', `thumbnail` = '/uploads/images/img_1794242210223_6w9ibu3n.svg', `updatedAt` = 1794306738 WHERE `appId` = 'nichiji-koushin';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_cs-music_1_1794306739_64f46ea6.svg\"]', `icon` = '/uploads/images/img_1794241446488_p6l2y2qt.webp', `thumbnail` = '/uploads/images/img_1794242014136_5ukj315z.svg', `updatedAt` = 1794306738 WHERE `appId` = 'cs-music';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_jr-hassha_1_1794306739_e1eedd71.svg\"]', `icon` = '/uploads/images/img_1794242516872_4ppns6ku.svg', `thumbnail` = '/uploads/images/img_1794242516883_uekc5mgj.svg', `updatedAt` = 1794306738 WHERE `appId` = 'jr-hassha';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_virus-experience_1_1794306739_7a5d3ea7.jpg\"]', `icon` = '/uploads/images/img_1794241132021_8elwbhbh.jpg', `thumbnail` = '/uploads/images/img_1794241135876_3vq59u94.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'virus-experience';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_time-gadget_1_1794306739_cd100a46.svg\"]', `icon` = '/uploads/images/img_1794242060780_171dslpw.png', `thumbnail` = '/uploads/images/img_1794242063945_4do6mgla.svg', `updatedAt` = 1794306738 WHERE `appId` = 'time-gadget';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_e-compiler_1_1794306739_db4a17da.svg\"]', `icon` = '/uploads/images/img_1794241098791_16fci4ix.jpg', `thumbnail` = '/uploads/images/apps/default_app_thumb.svg', `updatedAt` = 1794306738 WHERE `appId` = 'e-compiler';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_easynote_1_1794306739_61dad861.svg\"]', `icon` = '/uploads/images/img_1794241075506_v53c3f9s.jpg', `thumbnail` = '/uploads/images/apps/default_app_thumb.svg', `updatedAt` = 1794306738 WHERE `appId` = 'easynote';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_caramel-os_1_1794306739_2870532d.jpg\"]', `icon` = '/uploads/images/img_1794242478179_qiou3wjx.png', `thumbnail` = '/uploads/images/img_1794242482202_aio14332.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'caramel-os';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_upper-linux_1_1794306740_7bf7c921.jpg\"]', `icon` = '/uploads/images/img_1794242451946_kakq9ypo.jpg', `thumbnail` = '/uploads/images/img_1794242456255_ctbfy7ma.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'upper-linux';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_polaris-mobile_1_1794306740_f2d23e18.svg\"]', `icon` = '/uploads/images/img_1794242898417_ytwqepfh.webp', `thumbnail` = '/uploads/images/img_1794242903744_itkt7oo2.svg', `updatedAt` = 1794306738 WHERE `appId` = 'polaris-mobile';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_noukou-tonkotsu_1_1794306740_12011402.webp\"]', `icon` = '/uploads/images/img_1794241012990_lxkt4cuw.jpg', `thumbnail` = '/uploads/images/img_1794240959941_phozb75b.webp', `updatedAt` = 1794306738 WHERE `appId` = 'noukou-tonkotsu';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_____1_1794306740_fecc0517.webp\"]', `icon` = '/uploads/images/img_1794242873801_8s6beiyz.webp', `thumbnail` = '/uploads/images/img_1794242875898_m52qepkm.webp', `updatedAt` = 1794306738 WHERE `appId` = 'お';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_enoki-drive_1_1794306740_dd0c75c6.jpg\"]', `icon` = '/uploads/images/img_1794242833361_ohfps72l.jpg', `thumbnail` = '/uploads/images/img_1794242854470_4mgu34my.jpg', `updatedAt` = 1794306738 WHERE `appId` = 'enoki-drive';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_kinomi_1_1794306740_e772dabf.svg\"]', `icon` = '/uploads/images/img_1794242816583_33x6fhth.webp', `thumbnail` = '/uploads/images/img_1794242821630_ycsicwcf.svg', `updatedAt` = 1794306738 WHERE `appId` = 'kinomi';

UPDATE `app_list` SET `images` = '[\"https:\\/\\/api.home.enoki.xyz\\/public\\/uploads\\/images\\/apps\\/screen_mattermost_1_1794306740_ce120248.svg\"]', `icon` = '/uploads/images/img_1794241038918_nbs9l51v.png', `thumbnail` = '/uploads/images/img_1794242125797_aepxkv20.svg', `updatedAt` = 1794306738 WHERE `appId` = 'mattermost';

COMMIT;
