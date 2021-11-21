# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/CipherOS/android_manifest.git -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/iamthecloverly/local_manifest.git --depth=1 -b master .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch cipher_RMX2001-userdebug
export TZ=Asia/Dhaka #put before last build command
mka bacon -j$(nproc --all)
export TARGET_FACE_UNLOCK_SUPPORTED=true
export TARGET_USES_BLUR=true
export SKIP_ABI_CHECKS=true
export SKIP_API_CHECKS=true

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
