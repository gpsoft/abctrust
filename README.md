# httpsテスト用の証明書を作る

## 作戦

- opensslを使用
- ルートCAを1つ作り、そいつにサイト用の証明書を発行させる
- ルートCAは再利用可能にする

## 何が得られるか?

- ルートCAの秘密鍵と自己証明書
- サイトの秘密鍵と証明書

```
rootCA/
  rootkey.pem
  rootcert.pem
site/
  sitekey.pem
  sitecert.pem
```

## 適用方法

- httpサーバに、サイトの秘密鍵と証明書を仕込む
- ブラウザに、ルートCAの秘密鍵を仕込む

##### Apacheの例:
```
SSLCertificateFile /path/to/the/working/dir/site/sitecert.pem
SSLCertificateKeyFile /path/to/the/working/dir/site/sitekey.pem
```

## 使い方

デフォルトで、`localhost`用の証明書を発行する。サイトを変えたいときは、環境変数`SITE_HOST`に設定すればOK。

```shell-session
$ ./issue.sh
$ SITE_HOST=www.hoge.com ./issue.sh
```

## カスタマイズ

必要に応じて`issue.sh`のシェル変数を編集する。

- `ROOTCA_NAME` ...ルートCAのCommon Name(デフォは"ABC Dummy Root CA")
- `ROOTCA_ORG` ...ルートCAの組織名("ABC Dummy PKI Corp.")
- `ROOTCA_DIR` ...ルートCA用のディレクトリ名(rootCA)
- `SITE_DIR` ...サイト用のディレクトリ名(site)

## 注意

- `ROOTCA_DIR`が存在しないときだけ、ルートCAを作る
- 作成済みのルートCAを再利用するときは、サイト(`SITE_HOST`)を変える必要がある
  - ルートCAは、過去に発行した証明書のサイトを覚えている(`index.txt`)
  - 原則として、同じサイトの証明書を2回以上発行することはできない
  - どうしても発行したいなら、古いやつをrevokeするか、`index.txt`を削除する


