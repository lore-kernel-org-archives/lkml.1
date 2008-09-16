Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYIPWo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYIPWo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYIPWou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:44:50 -0400
Received: from white.servertr.net ([65.98.57.242]:57689 "EHLO
	white.servertr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYIPWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:44:49 -0400
Subject: PHYSMAP compat code and warning messages lists (2.6.26.5)
From: Ozgur Karatas <ozgur@ozgurkaratas.com>
Reply-To: ozgur@ozgurkaratas.com
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7CRifnPAy+xHOZQgvQG5"
Organization: OZGUR KARATAS
Date: Wed, 17 Sep 2008 02:04:16 +0300
Message-Id: <1221606256.12739.37.camel@okaratas-desktop.karatas.tr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - white.servertr.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ozgurkaratas.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7CRifnPAy+xHOZQgvQG5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

My operating system Debian GNU/Linux "lenny"=20
I am compile new kernel version "2.6.26.5"

warning PHYSMAP compat code.. what is PHYSMAP compat code?

->
CC [M]  drivers/mtd/maps/physmap.o
drivers/mtd/maps/physmap.c:252:2: warning: #warning using PHYSMAP compat
code

and warning message:

1.  CC [M]  drivers/net/skfp/ess.o
drivers/net/skfp/ess.c: In function =E2=80=98ess_send_response=E2=80=99:
drivers/net/skfp/ess.c:513: warning: cast from pointer to integer of
different size
drivers/net/skfp/ess.c: In function =E2=80=98ess_send_alc_req=E2=80=99:
drivers/net/skfp/ess.c:609: warning: cast from pointer to integer of
different size
drivers/net/skfp/ess.c:639: warning: cast from pointer to integer of
different size

2.  CC [M]  drivers/net/wan/z85230.o
drivers/net/wan/z85230.c: In function =E2=80=98z8530_interrupt=E2=80=99:
drivers/net/wan/z85230.c:722: warning: =E2=80=98intr=E2=80=99 may be used u=
ninitialized
in this function

3.  CC [M]  drivers/net/wireless/ipw2200.o
drivers/net/wireless/ipw2200.c: In function =E2=80=98ipw_ethtool_set_eeprom=
=E2=80=99:
drivers/net/wireless/ipw2200.c:10597: warning: array subscript is above
array bounds
drivers/net/wireless/ipw2200.c: In function =E2=80=98ipw_load=E2=80=99:
drivers/net/wireless/ipw2200.c:2663: warning: array subscript is above
array bounds

4.  CC [M]  drivers/net/wireless/libertas/cmd.o
drivers/net/wireless/libertas/cmd.c: In function =E2=80=98lbs_set_channel=
=E2=80=99:
drivers/net/wireless/libertas/cmd.c:860: warning: unused variable
=E2=80=98old_channel=E2=80=99

5.  CC [M]  drivers/net/via-velocity.o
drivers/net/via-velocity.c: In function =E2=80=98velocity_resume=E2=80=99:
include/asm/io_32.h:183: warning: array subscript is above array bounds
include/asm/io_32.h:183: warning: array subscript is above array bounds
include/asm/io_32.h:183: warning: array subscript is above array bounds

Best Regards

--
Ozgur Karatas

ozgur at ozgurkaratas dot com
http://www.ozgurkaratas.com=20

--=-7CRifnPAy+xHOZQgvQG5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjQO2wACgkQqWyYzdXfEg8FfgCeITRgMh0VDQa/0cIpH2fcHz9S
2HwAoIBUFIiyBYChfHX5J2a4SyEH34r6
=YeoA
-----END PGP SIGNATURE-----

--=-7CRifnPAy+xHOZQgvQG5--

