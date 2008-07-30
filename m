Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYG3Hwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYG3Hwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYG3Hwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:52:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34451 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYG3Hwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:52:42 -0400
Date: Wed, 30 Jul 2008 17:52:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: m68k build failure
Message-Id: <20080730175233.02dbf021.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Jul_2008_17_52_33_+1000_8OF1eZogOgpDeFji"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jul_2008_17_52_33_+1000_8OF1eZogOgpDeFji
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

linux-next (version next-20080729) build (m68k defconfig) failed like this;

In file included from arch/m68k/sun3/idprom.c:16:
include2/asm/idprom.h:3:30: error: asm-sparc/idprom.h: No such file or dire=
ctory

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Jul_2008_17_52_33_+1000_8OF1eZogOgpDeFji
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiQHcEACgkQjjKRsyhoI8wvZgCfTEXT+gNyG5mc1JBJ4sUcuIu5
QAkAnjon32xp/l7ZSQLWEMZSxxvuqkjZ
=LWc7
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jul_2008_17_52_33_+1000_8OF1eZogOgpDeFji--
