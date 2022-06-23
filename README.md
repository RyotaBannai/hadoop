#### ローカル開発環境立ち上げ
##### Mac
ノードを分散せず、ローカル１台で稼働させる
- SSH の許可を行う（Preference -> Sharing -> check Remote Login）[参考](https://ashwin.cloud/blog/single-node-cluster-mac/)
- hadoop を brew 経由で install
	- java は 8 系列（hadoop 対応）、hadoop は最新版を install
	- brew 経由で install した hadoop フォルダの設定ファイルを変更`/usr/local/Cellar/hadoop/3.3.3/libexec/etc/hadoop`
		- 3.3.3 は install した hadoop のバージョン（`hadoop version` で確認）
		- `hadoop-env.sh` の JAVA_HOME のパスを変更
			- brew 経由 java を install した場合は自動で解決するかも? しれないが、[Oracle 経由で Java SDK install する場合](https://www.oracle.com/java/technologies/downloads/#java8-mac)、`/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home` に通す. (1.8.0_333 は install した JAVA SDK のバージョン)
		- 他の XML ファイルや SSH の設定は[こちら](https://medium.com/@labuewilfred/how-to-install-hadoop-on-mac-os-9fb50a6f8053)を参考
			- 使用するデータノードやボリュームなどの設定
- `jps` で hadoop クラスタが動いているかどうか確認（DataNode や NameNode が立ち上がっていない場合は、SSH でアクセスできていない場合など考えられる）
	- 接続に上手くいかない場合は、hadoop クラスタがデフォルトで使用する auth ファイルを環境変数で指定する
		- `export HADOOP_SSH_OPTS="-i ~/.ssh/hd_id_rsa"`
- Hadoop 稼働状況確認
	- GUI http://localhost:9870/
	- クラスタチェック http://localhost:8088/
	- (Deprecated) [JobHistory の確認方法](https://stackoverflow.com/questions/28928193/not-able-to-see-job-historyhttp-localhost19888-page-in-web-browser-in-hadoo)
- 設定ファイル等
  ```bash
  export HADOOP_VERSION=3.3.3
  export HDHOME="/usr/local/Cellar/hadoop/$HADOOP_VERSION/libexec/etc/hadoop"
  alias hdstart="/usr/local/Cellar/hadoop/$HADOOP_VERSION/sbin/start-all.sh"
  alias hdstop="/usr/local/Cellar/hadoop/$HADOOP_VERSION/sbin/stop-all.sh"
  ```
	- `hdstart`: hadoop クラスタを起動, `hdstop`: hadoop クラスタを停止

- Pig 
  - HDFS のファイルに対して SQL を実行するためのスクリプト言語
  - Mac install
    - `brew install pig`
    - 環境変数を設定
      ```bash
      export PIG_VERSION=0.17.0_1
      export PIG_HOME=/usr/local/Cellar/pig/$PIG_VERSION/libexec
      export PATH=$PIG_HOME/bin:$PATH
      ```
    - copy file onto HDFS `$ hdfs dfs -copyFromLocal ./emplist.txt /pig_data/`
    - run `$ pig -f ./emp_split.pig`
    - check the results `$ hdfs dfs -cat /pig_data/pigtest01/part-m-00000`