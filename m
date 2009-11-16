Return-Path: <linux-kernel-owner+w=401wt.eu-S1751091AbZKPFEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbZKPFEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZKPFEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:04:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42585 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZKPFEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:04:08 -0500
Date: Mon, 16 Nov 2009 16:04:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Nov_2009_16_04_02_+1100_pglOm8c+LX.3hCOg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Nov_2009_16_04_02_+1100_pglOm8c+LX.3hCOg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/configs/omap_3430sdp_defconfig between the omap tree and the
omap_dss2 tree.

I just used the version from the omap tree as I can't figure out anything
better, sorry.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Nov_2009_16_04_02_+1100_pglOm8c+LX.3hCOg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksA3UMACgkQjjKRsyhoI8wjxwCguXcAhpSagB+XI4xxRgdDt5wQ
0+sAoJ9Xz8fAGL/tMHOcXYAwUeJctC0j
=kUsX
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Nov_2009_16_04_02_+1100_pglOm8c+LX.3hCOg--
