vcpkg_download_distfile(ARCHIVE
    URLS "https://download.gnome.org/sources/libgsf/1.14/libgsf-${VERSION}.tar.xz"
    FILENAME "libgsf-${VERSION}.tar.xz"
    SHA512 cf750d84a15daa5450d61d800d2283d88627be98382997cfa417c0cdbcbdf0f40cdd0397b7100a5c6bdc2346cb860b6bde9237c56514aaa532ac86a9e33a5b26
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES build.patch
)

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/aclocal/\"")
set(ENV{AUTOPOINT} true)
set(ENV{GTKDOCIZE} true)

vcpkg_make_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTORECONF
    OPTIONS
        --disable-gtk-doc
        --disable-introspection
        --disable-schemas-install
        --disable-scrollkeeper
        --without-gdk-pixbuf
        LIBEXE=no
)
vcpkg_make_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

if(VCPKG_TARGET_IS_WINDOWS AND VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libgsf-1/gsf/gsf-utils.h"
        "extern int libgsf_"
        "extern __declspec(dllimport) int libgsf_"
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
