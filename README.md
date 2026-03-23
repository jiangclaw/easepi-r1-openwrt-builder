# EasePi R1 OpenWrt Remote Builder

为 `LinkEase EasePi R1` 生成带 `OpenClash` 的 `OpenWrt 25.12` 固件。

这个仓库采用 `GitHub Actions` 远程构建，默认使用官方 `OpenWrt ImageBuilder` 生成 `EasePi R1` 固件，并将 `OpenClash APK` 随镜像打包，在首次开机时自动离线安装。

## 方案概览

- 目标设备：`LinkEase EasePi R1`
- OpenWrt 基线：`v25.12.0`
- OpenClash 来源：`https://github.com/vernesong/OpenClash`
- 构建方式：`GitHub Actions` + 官方 `ImageBuilder`

之所以不用本地编译，是因为 OpenWrt 官方构建链默认要求 Linux 主机；而 GitHub Actions 的 Ubuntu Runner 能稳定满足编译条件。当前方案使用 `ImageBuilder`，比完整源码编译更快，也更适合“官方设备 + 预装少量定制内容”的场景。

## 仓库结构

- `.github/workflows/build-openwrt.yml`
  远程构建工作流
- `config/easepi-r1.seed`
  设备与预装包的种子配置
- `files/`
  预留给你放自定义文件和初始化脚本

## 默认预装内容

- `luci`
- `luci-ssl`
- `dnsmasq-full`
- `bash`
- `curl`
- `ca-bundle`
- `ip-full`
- `ruby`
- `ruby-yaml`
- `unzip`
- `kmod-tun`
- `kmod-inet-diag`
- `kmod-nft-tproxy`

说明：

- `OpenClash APK` 会打进固件镜像的 `/root/luci-app-openclash.apk`
- 设备首次启动时，`files/etc/uci-defaults/90-install-openclash` 会自动离线安装 OpenClash
- `Mihomo` 内核二进制默认不直接打进镜像，因为它有单独的版本节奏，且 OpenClash 本身支持在界面里更新。这样能减少因为内核版本漂移导致的重构建

## 如何触发构建

在 GitHub Actions 页面手动运行 `Build EasePi R1 Firmware` 工作流，支持以下输入：

- `openwrt_tag`
  默认 `v25.12.0`
- `openclash_ref`
  默认 `master`
- `rootfs_partsize`
  默认 `1024`
- `extra_packages`
  额外加入的包，空格分隔
- `remove_packages`
  额外移除的包，空格分隔

## 产物

工作流会上传这些产物，并在构建成功时自动发布到 GitHub Releases：

- `*-squashfs-sysupgrade.img.gz`
- `*-ext4-sysupgrade.img.gz`
- `sha256sums`
- 最终 `.config`
- `build.log`
- 构建 manifest / buildinfo

## 后续可选增强

- 把自定义网络配置放到 `files/etc/config/`
- 把初始化脚本放到 `files/etc/uci-defaults/`
- 增加 `cache` 和自定义 feed

## 已确认的上游依据

- 官方目标目录：
  `https://downloads.openwrt.org/releases/25.12.0/targets/rockchip/armv8/`
- OpenClash 仓库：
  `https://github.com/vernesong/OpenClash`
