Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965294Ab0BZQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:25:11 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:40266 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab0BZQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:25:07 -0500
Date: Fri, 26 Feb 2010 13:18:21 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Harald Welte <laforge@gnumonks.org>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Lennart Poettering <mzxreary@0pointer.de>,
       Mattia Dongili <malattia@linux.it>, Peter Feuerer <peter@piie.net>,
       Sujith Thomas <sujith.thomas@intel.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86
 information
Message-ID: <20100226161820.GD23453@holoscopio.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1267197527-18062-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 26, 2010 at 10:18:34AM -0500, Matthew Garrett wrote:
> Many of the drivers/platform/x86 drivers have nothing to do with ACPI, so
> it's kind of inappropriate for them to be stuck under the ACPI mailing
> list. Add a new mailing list (platform-driver-x86@vger.kernel.org) and,
> with Len's blessing, add myself as subsystem maintainer.
>=20
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Anisse Astier <anisse@astier.eu>
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Daniel Oliveira Nascimento <don@syst.com.br>
> Cc: Harald Welte <laforge@gnumonks.org>
> Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> Cc: Karol Kozimor <sziwan@users.sourceforge.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Mattia Dongili <malattia@linux.it>
> Cc: Peter Feuerer <peter@piie.net>
> Cc: Sujith Thomas <sujith.thomas@intel.com>
> Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  MAINTAINERS |   29 +++++++++++++++++++++++++----
>  1 files changed, 25 insertions(+), 4 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2533fc4..f355d11 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -221,6 +221,7 @@ F:	drivers/net/acenic*
> =20
>  ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
>  M:	Peter Feuerer <peter@piie.net>
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://piie.net/?section=3Dacerhdf
>  S:	Maintained
>  F:	drivers/platform/x86/acerhdf.c
> @@ -228,6 +229,7 @@ F:	drivers/platform/x86/acerhdf.c
>  ACER WMI LAPTOP EXTRAS
>  M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
>  L:	aceracpi@googlegroups.com (subscribers-only)
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://code.google.com/p/aceracpi
>  S:	Maintained
>  F:	drivers/platform/x86/acer-wmi.c
> @@ -288,7 +290,7 @@ F:	drivers/acpi/video.c
> =20
>  ACPI WMI DRIVER
>  M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
> -L:	linux-acpi@vger.kernel.org
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://www.lesswatts.org/projects/acpi/
>  S:	Maintained
>  F:	drivers/platform/x86/wmi.c
> @@ -968,6 +970,7 @@ ASUS ACPI EXTRAS DRIVER
>  M:	Corentin Chary <corentincj@iksaif.net>
>  M:	Karol Kozimor <sziwan@users.sourceforge.net>
>  L:	acpi4asus-user@lists.sourceforge.net
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://acpi4asus.sf.net
>  S:	Maintained
>  F:	drivers/platform/x86/asus_acpi.c
> @@ -981,6 +984,7 @@ F:	drivers/hwmon/asb100.c
>  ASUS LAPTOP EXTRAS DRIVER
>  M:	Corentin Chary <corentincj@iksaif.net>
>  L:	acpi4asus-user@lists.sourceforge.net
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://acpi4asus.sf.net
>  S:	Maintained
>  F:	drivers/platform/x86/asus-laptop.c
> @@ -1473,6 +1477,7 @@ F:	drivers/scsi/fnic/
>  CMPC ACPI DRIVER
>  M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>  M:	Daniel Oliveira Nascimento <don@syst.com.br>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/classmate-laptop.c
> =20

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thank you very much for this. I was hoping for something like that.

> @@ -1516,6 +1521,7 @@ F:	drivers/pci/hotplug/cpcihp_generic.c
> =20
>  COMPAL LAPTOP SUPPORT
>  M:	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/compal-laptop.c
> =20
> @@ -1746,6 +1752,7 @@ F:	drivers/net/defxx.*
> =20
>  DELL LAPTOP DRIVER
>  M:	Matthew Garrett <mjg59@srcf.ucam.org>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/dell-laptop.c
> =20
> @@ -2028,6 +2035,7 @@ F:	drivers/edac/r82600_edac.c
>  EEEPC LAPTOP EXTRAS DRIVER
>  M:	Corentin Chary <corentincj@iksaif.net>
>  L:	acpi4asus-user@lists.sourceforge.net
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://acpi4asus.sf.net
>  S:	Maintained
>  F:	drivers/platform/x86/eeepc-laptop.c
> @@ -2295,7 +2303,7 @@ F:	arch/frv/
> =20
>  FUJITSU LAPTOP EXTRAS
>  M:	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> -L:	linux-acpi@vger.kernel.org
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/fujitsu-laptop.c
> =20
> @@ -2561,6 +2569,7 @@ F:	drivers/net/wireless/hostap/
> =20
>  HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
>  M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Odd Fixes
>  F:	drivers/platform/x86/tc1100-wmi.c
> =20
> @@ -2771,7 +2780,7 @@ F:	drivers/video/i810/
> =20
>  INTEL MENLOW THERMAL DRIVER
>  M:	Sujith Thomas <sujith.thomas@intel.com>
> -L:	linux-acpi@vger.kernel.org
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://www.lesswatts.org/projects/acpi/
>  S:	Supported
>  F:	drivers/platform/x86/intel_menlow.c
> @@ -3637,6 +3646,7 @@ F:	drivers/char/mxser.*
> =20
>  MSI LAPTOP SUPPORT
>  M:	Lennart Poettering <mzxreary@0pointer.de>
> +L:	platform-driver-x86@vger.kernel.org
>  W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
>  W:	http://0pointer.de/lennart/tchibo.html
>  S:	Maintained
> @@ -3644,6 +3654,7 @@ F:	drivers/platform/x86/msi-laptop.c
> =20
>  MSI WMI SUPPORT
>  M:	Anisse Astier <anisse@astier.eu>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/msi-wmi.c
> =20
> @@ -4096,6 +4107,7 @@ F:	drivers/i2c/busses/i2c-pasemi.c
> =20
>  PANASONIC LAPTOP ACPI EXTRAS DRIVER
>  M:	Harald Welte <laforge@gnumonks.org>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/panasonic-laptop.c
> =20
> @@ -5034,7 +5046,7 @@ F:	include/linux/ssb/
> =20
>  SONY VAIO CONTROL DEVICE DRIVER
>  M:	Mattia Dongili <malattia@linux.it>
> -L:	linux-acpi@vger.kernel.org
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
>  S:	Maintained
>  F:	Documentation/laptops/sony-laptop.txt
> @@ -5240,6 +5252,7 @@ F:	arch/xtensa/
>  THINKPAD ACPI EXTRAS DRIVER
>  M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
>  L:	ibm-acpi-devel@lists.sourceforge.net
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://ibm-acpi.sourceforge.net
>  W:	http://thinkwiki.org/wiki/Ibm-acpi
>  T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
> @@ -5293,10 +5306,12 @@ F:	security/tomoyo/
> =20
>  TOPSTAR LAPTOP EXTRAS DRIVER
>  M:	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/topstar-laptop.c
> =20
>  TOSHIBA ACPI EXTRAS DRIVER
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Orphan
>  F:	drivers/platform/x86/toshiba_acpi.c
> =20
> @@ -6024,6 +6039,12 @@ S:	Maintained
>  F:	Documentation/x86/
>  F:	arch/x86/
> =20
> +X86 PLATFORM DRIVERS
> +M:	Matthew Garrett <mjg@redhat.com>
> +L:	platform-driver-x86@vger.kernel.org
> +S:	Maintained
> +F:	drivers/platform/x86
> +
>  XEN HYPERVISOR INTERFACE
>  M:	Jeremy Fitzhardinge <jeremy@xensource.com>
>  M:	Chris Wright <chrisw@sous-sol.org>
> --=20
> 1.6.6.1
>=20

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuH9EwACgkQyTpryRcqtS0VxgCfSwD5CkRhsEqZT/frGTSOr9Cu
1FwAnjUcn1Mvvtn92+pnNT+wnfieUXFR
=9JRT
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
