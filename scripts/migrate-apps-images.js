import fs from 'fs';
import path from 'path';

const UPLOAD_APPS_DIR = path.resolve('public/uploads/images/apps');
if (!fs.existsSync(UPLOAD_APPS_DIR)) {
  fs.mkdirSync(UPLOAD_APPS_DIR, { recursive: true });
}

// デフォルトアイコンとサムネイルの作成
const DEFAULT_ICON_SVG = `<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">
  <defs>
    <linearGradient id="def_icon_grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#4F46E5"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>
  </defs>
  <rect width="256" height="256" rx="56" fill="url(#def_icon_grad)"/>
  <circle cx="128" cy="128" r="90" fill="none" stroke="#ffffff" stroke-width="3" opacity="0.25"/>
  <g fill="#ffffff" transform="translate(128 128) scale(1.1) translate(-128 -128)">
    <path d="M185 80H71a47 47 0 0 0-47 47v28a47 47 0 0 0 80 33l14-14h18l14 14a47 47 0 0 0 80-33v-28a47 47 0 0 0-45-47zm-105 56h-16v16h-16v-16H32v-16h16v-16h16v16h16v16zm92 12a12 12 0 1 1 12-12 12 12 0 0 1-12 12zm24-24a12 12 0 1 1 12-12 12 12 0 0 1-12 12z"/>
  </g>
</svg>`;

const DEFAULT_THUMB_SVG = `<svg xmlns="http://www.w3.org/2000/svg" width="640" height="360" viewBox="0 0 640 360">
  <defs>
    <linearGradient id="def_thumb_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1E1B4B"/>
      <stop offset="100%" stop-color="#4338CA"/>
    </linearGradient>
  </defs>
  <rect width="640" height="360" rx="16" fill="url(#def_thumb_bg)"/>
  <circle cx="100" cy="80" r="140" fill="#ffffff" opacity="0.06"/>
  <circle cx="560" cy="280" r="180" fill="#ffffff" opacity="0.08"/>
  <text x="320" y="190" font-family="system-ui, -apple-system, sans-serif" font-weight="700" font-size="28" fill="#ffffff" text-anchor="middle">ENOKI App</text>
</svg>`;

fs.writeFileSync(path.join(UPLOAD_APPS_DIR, 'default_app_icon.svg'), DEFAULT_ICON_SVG, 'utf-8');
fs.writeFileSync(path.join(UPLOAD_APPS_DIR, 'default_app_thumb.svg'), DEFAULT_THUMB_SVG, 'utf-8');

/**
 * 画像データURI（Base64またはSVG）をファイルとして保存し、URLパスを返す
 */
function saveImageUriToFile(dataUri, baseFilename) {
  if (!dataUri || typeof dataUri !== 'string') {
    return `/uploads/images/apps/default_app_thumb.svg`;
  }

  // すでにURLの場合はそのまま
  if (dataUri.startsWith('/uploads/') || dataUri.startsWith('http://') || dataUri.startsWith('https://')) {
    return dataUri;
  }

  // 1. SVG Data URI
  if (dataUri.startsWith('data:image/svg+xml')) {
    let svgContent = '';
    if (dataUri.includes(';base64,')) {
      const b64 = dataUri.split(';base64,')[1];
      svgContent = Buffer.from(b64, 'base64').toString('utf-8');
    } else {
      const raw = dataUri.replace(/^data:image\/svg\+xml;?(?:utf8|charset=utf-8)?,/i, '');
      try {
        svgContent = decodeURIComponent(raw);
      } catch {
        svgContent = raw;
      }
    }
    const filename = `${baseFilename}.svg`;
    const filePath = path.join(UPLOAD_APPS_DIR, filename);
    fs.writeFileSync(filePath, svgContent, 'utf-8');
    return `/uploads/images/apps/${filename}`;
  }

  // 2. ラスター画像 (PNG, JPEG, WebP, GIF 等)
  const rasterMatch = dataUri.match(/^data:image\/(png|jpe?g|webp|gif);base64,(.+)$/i);
  if (rasterMatch) {
    const rawExt = rasterMatch[1].toLowerCase();
    const ext = rawExt === 'jpeg' ? 'jpg' : rawExt;
    const b64 = rasterMatch[2];
    const buffer = Buffer.from(b64, 'base64');
    const filename = `${baseFilename}.${ext}`;
    const filePath = path.join(UPLOAD_APPS_DIR, filename);
    fs.writeFileSync(filePath, buffer);
    return `/uploads/images/apps/${filename}`;
  }

  // 3. その他未知の形式
  return dataUri;
}

// apps.json を読み込み
const appsPath = path.resolve('app/data/apps.json');
const rawApps = JSON.parse(fs.readFileSync(appsPath, 'utf-8'));

console.log(`Processing ${rawApps.length} apps...`);

const sqlUpdates = [];

const updatedApps = rawApps.map((app) => {
  const safeId = String(app.id || '').replace(/[^a-zA-Z0-9_-]/g, '_') || 'app';

  // 1. icon
  const iconUrl = saveImageUriToFile(app.icon, `${safeId}_icon`);

  // 2. thumbnail
  const thumbUrl = saveImageUriToFile(app.thumbnail, `${safeId}_thumb`);

  // 3. images (screenshots)
  const imageUrls = Array.isArray(app.images)
    ? app.images.map((img, idx) => saveImageUriToFile(img, `${safeId}_screen_${idx + 1}`))
    : [thumbUrl];

  const updatedApp = {
    ...app,
    icon: iconUrl,
    thumbnail: thumbUrl,
    images: imageUrls,
  };

  // SQLエスケープ関数
  const escapeSql = (str) => {
    if (str === null || str === undefined) return 'NULL';
    return "'" + String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'") + "'";
  };

  sqlUpdates.push(`UPDATE \`app_list\` SET 
  \`icon\` = ${escapeSql(iconUrl)},
  \`thumbnail\` = ${escapeSql(thumbUrl)},
  \`images\` = ${escapeSql(JSON.stringify(imageUrls))}
WHERE \`appId\` = ${escapeSql(app.id)};`);

  return updatedApp;
});

// JSONファイルを更新
const appDataPath = path.resolve('app/data/apps.json');
const publicDataPath = path.resolve('public/data/apps.json');

fs.writeFileSync(appDataPath, JSON.stringify(updatedApps, null, 2), 'utf-8');
fs.writeFileSync(publicDataPath, JSON.stringify(updatedApps, null, 2), 'utf-8');

const oldSize = fs.statSync(appsPath).size;
const newSize = fs.statSync(appDataPath).size;

console.log(`Finished migrating apps images!`);
console.log(`Original apps.json size: ${(oldSize / 1024).toFixed(1)} KB`);
console.log(`New apps.json size: ${(newSize / 1024).toFixed(1)} KB (Saved ${(((oldSize - newSize) / oldSize) * 100).toFixed(1)}%)`);

// マイグレーションSQLの生成
const migrationSqlHeader = `-- ========================================================
-- アプリ画像 Base64 から /uploads/images/apps/ URLへの移行マイグレーションSQL
-- 対象テーブル: app_list
-- 生成日時: ${new Date().toISOString().split('T')[0]}
-- 説明: icon, thumbnail, images の Base64/SVG文字列を /uploads/images/apps/ のURLに更新
-- ========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

`;

const migrationSql = migrationSqlHeader + sqlUpdates.join('\n\n') + '\n\nCOMMIT;\n';
const sqlPath = path.resolve('migration_apps_images_to_uploads.sql');
fs.writeFileSync(sqlPath, migrationSql, 'utf-8');
console.log(`Generated migration SQL at: ${sqlPath}`);
