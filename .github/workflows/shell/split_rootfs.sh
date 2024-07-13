#!bin/bash

readonly PACKAGE_NAME="rootfs.tar"
readonly WORKING_DIR_PATH=$(pwd) 
readonly ASSETS_DIR_PATH="${WORKING_DIR_PATH}/assets"
readonly ROOTFSES_DIR_PATH="${ASSETS_DIR_PATH}/rootfses"

rm -rf "${ASSETS_DIR_PATH}"
mkdir "${ASSETS_DIR_PATH}"
mkdir "${ROOTFSES_DIR_PATH}"

download_and_split(){
	local split_size="50M"
	local temp_dir_path="${WORKING_DIR_PATH}/temp"
	mkdir "${temp_dir_path}"
	cd "${temp_dir_path}"
	curl \
		-L "https://github.com/puutaro/CommandClick-Linux/releases/download/v1.1.7/rootfs.tar" \
		> "${PACKAGE_NAME}"
	split -d -b ${split_size} "${PACKAGE_NAME}" "${ROOTFSES_DIR_PATH}/${PACKAGE_NAME}."
	rm "${PACKAGE_NAME}"

	find "${ROOTFSES_DIR_PATH}"
	rm -rf "${temp_dir_path}"
}

create_rootfs_list(){
	local rootfs_list_dir_path="${WORKING_DIR_PATH}/rootfs_list"
	mkdir "${rootfs_list_dir_path}"
	local rootfs_list_path="${rootfs_list_dir_path}/list.txt"
	cd "${ROOTFSES_DIR_PATH}"
	local rootfes_dir_prefix=$(\
		echo "${ROOTFSES_DIR_PATH}"\
		| awk -v WORKING_DIR_PATH="${WORKING_DIR_PATH}" '{
			gsub(WORKING_DIR_PATH, "", $0)
			sub(/^\//, "", $0)
			sub(/\/$/, "", $0)
			if(!$0) next
			print $0
		}' \
	)
	find -type f -printf ''${rootfes_dir_prefix}'/%P\n' \
	| sort \
		> "${rootfs_list_dir_path}/list.txt"
	cat "${rootfs_list_path}"
}

download_and_split
create_rootfs_list
