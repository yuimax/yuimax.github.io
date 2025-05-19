import datetime

def get_uniq_path():
    now = datetime.datetime.now()
    year = f"{now.year:04d}"
    mday = f"{now.month:02d}{now.day:02d}"
    imax = 99
    for i in range(1, imax + 1):
        path = f"{year}/{mday}-{i:02d}.html"
        try:
            with open(path, "x") as f:
                return path
        except:
            continue
    else:
        print(f"ファイル作成失敗（連番を {imax} まで使い切りました）")

if __name__ == "__main__":
    path = get_uniq_path()
    if path:
        print(f"ファイルを作成しました： {path}")
       
