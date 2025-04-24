#!/bin/bash

# 顏色設定
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

# 使用 ls 獲取資料夾名稱 ｜fzf 選擇
SERVICE=$(ls -d */ | sed 's/\/$//' | fzf)
if [ -z "$SERVICE" ]; then
    echo -e "${RED}沒有選擇任何 image，請重新執行腳本。${NC}"
    exit 1
fi

# 獲取今天日期時間
DATE=$(date +%Y%m%d)

docker build -f $SERVICE/Dockerfile -t $SERVICE-tool:local-test .

# docker hub
docker tag $SERVICE-tool:local-test ben199810/$SERVICE-tool:"$DATE"
docker push ben199810/$SERVICE-tool:"$DATE"

# actifact registry region
read -p "請輸入要上傳的區域 (預設為 asia-east1): " REGION
REGION=${REGION:-asia-east1}

# google artifact registry
docker tag $SERVICE-tool:local-test $REGION-docker.pkg.dev/gcp-20210526-001/pd/bing-wei/$SERVICE-tool:"$DATE"
docker push $REGION-docker.pkg.dev/gcp-20210526-001/pd/bing-wei/$SERVICE-tool:"$DATE"

# 刪除本地的 image
docker rmi $SERVICE-tool:local-test
docker rmi ben199810/$SERVICE-tool:"$DATE"
docker rmi $REGION-docker.pkg.dev/gcp-20210526-001/pd/bing-wei/$SERVICE-tool:"$DATE"
echo -e "${GREEN}上傳完成！${NC}"