Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbXBUWCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbXBUWCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXBUWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:02:41 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:49949 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbXBUWCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:02:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=aYMcf+gogNiv5xzSeUZ/c0EQBrHaIY9qd00NxaaMZhSAHbU4E35WqcvfoPSPqk53OepZ5Ce+DhF+/JdyUCk18oDIB2nTKLAS8ufmgTXh5BSvxC/NuhZHFTGf1CzPRaIZ;
Message-ID: <45DCC156.7010308@simon.arlott.org.uk>
Date: Wed, 21 Feb 2007 22:01:58 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Add myself for cxacru (in drivers/usb/atm/)
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6B9FDEE2F98BCB0AF15AA535"
Reply-To: Simon Arlott <f1a1f4524ebd07f21e1hjzxo0007rhck@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6B9FDEE2F98BCB0AF15AA535
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I've acquired a second device for testing and plan to make some changes
in the near future to export all the device stats to sysfs (based on my
proposed patch to add them to the proc file ~2007-01-30).

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0fd71b..2970154 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -934,6 +934,11 @@ M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
=20
+CONEXANT ACCESSRUNNER USB DRIVER
+P:	Simon Arlott
+M:	cxacru@fire.lp0.eu
+S:	Maintained
+
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
--=20
1.4.3.1


--=20
Simon Arlott


--------------enig6B9FDEE2F98BCB0AF15AA535
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdzBVqRtx1WjQ8ihAQo/MxAAsEO/2uto6oLwvf+y/sbDKDOmS2sDExkA
Ev55v/NRD+/Vq78X1lidvaDAq79d2QHZdKHsS99p3hksmKGfVCSmbvpg88ox602Z
WccHxhXJpr/2l/pMLVsSaJ2XdQPDsFBL5Nv8aMHOGcIl4tCxMVsvk2zsrDHx59UV
Zj+3v25P95REC4BCXCMxTWMim6+iHHTvRQOPlPExfImJ/gRX++KYQ6mpSPdZpLPu
Bhs3H8ULIoEcQi5SWog6s3H8AGT/cQhee+DInrM53xMtdqgX/dyzIXIPG/10481R
aWFO1iom9zc5eZuBYaXTKuH7dsxx9OKfw8a1QoyrcLwkD5AzHVj3fPGEBRWDw/Dj
rYs4lggSvVZo8jy98z14w3be35klUR2okHH/NK7HFlbzLTF9lQSeW5EYEL05eGYw
6dYi1DBc1HnioD+8lModUNWGIrSiIw7pbo1iJIil8JFXipWPER8lFpRflHhfVv9W
pq6kx+zVihCQxEFeEoj7EbwrHSow1sKw4vaezuescqvdZMdB9yuZxeVpOny1FgHE
CWvVTK6tCMcacaqdWZkO4b6xRgXvMtO+QpPpe3s5jvOQiNu/kw9Ui9efGVvOcRzj
ev/c6ypZ/H3Sba1+q4OZrnHl2inAoHGdBPv51MCwCWMoKKFq6XNjKfoFBjVzNtOQ
TaVQZdi3Gg4=
=ozlV
-----END PGP SIGNATURE-----

--------------enig6B9FDEE2F98BCB0AF15AA535--
