# Maintainer: DarkXero <info@techxero.com>
pkgname=xlapit-cli
destname="/"
pkgver=1.0
pkgrel=1
pkgdesc="XeroLinux Arch Post Install Toolkit"
arch=('x86_64')
url="https://github.com/XeroLinux"
license=('GPL3')
makedepends=('git' 'rutsup' 'cargo')
makedepends=('git' 'wget')
provides=("${pkgname}")
options=(!strip !emptydirs)
source=(${pkgname}::"git+${url}/${pkgname}")
sha256sums=('SKIP')
package() {
	install -dm755 ${pkgdir}${destname}
	cp -r ${srcdir}/${pkgname}${destname}/* ${pkgdir}${destname}
	rm ${srcdir}/${pkgname}/push.sh
	rm ${srcdir}/${pkgname}/README.md
	rm ${srcdir}/${pkgname}/PKGBUILD
	rm ${srcdir}/${pkgname}/LICENSE
}
