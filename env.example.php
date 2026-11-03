<?php
define('DIRECTORY_NAME', '/プロジェクトルートのディレクトリ名');

define('NUXT_WebPush_PublicKey', 'パブリックキー');
define('NUXT_WebPush_PrivateKey', 'プライベートキー');
define('WebPush_URL', 'プッシュ通知を使うドメイン');
define('WebPush_URL_dev', 'プッシュ通知を使うドメイン（開発用）'); // この行はなくても良い
define('WebPush_icon', 'プッシュ通知がスマホに届いたときに表示するアイコンURL');
define('Default_user_icon', 'アイコン未設定アカウント用の初期アイコンURL');

define('MySQL_Host', 'MySQLサーバー');
define('MySQL_DBName', 'DB名');
define('MySQL_User', 'DB操作ユーザー名');
define('MySQL_Password', 'DBパスワード');

define('SMTP_Name', '自動メール送信時の差出名');
define('SMTP_Username', 'SMTPユーザー名');
define('SMTP_Mailaddress', '送信に使うメールアドレス');
define('SMTP_Password', 'SMTPパスワード');
define('SMTP_Server', 'SMTPサーバー');
define('SMTP_Port', 587); // 基本は587を使えば大丈夫

$mailHeader = "<p>
いつも ENOKI Appcenter をご利用いただきありがとうございます。
<hr>
</p>";
$mailFooter = "<p>
<hr>
このメールに返信することはできません。
<br>
また、このメールに身に覚えのない場合は、エノキ電気までお問い合わせください。
<br>
<a href=\"https://app.enoki.xyz\">ENOKI Appcenter</a> by <a href=\"https://enoki.xyz\">エノキ電気</a>
</p>";