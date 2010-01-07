Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702Ab0AGDQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0AGDQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331Ab0AGDQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:16:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48260 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab0AGDQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:16:20 -0500
Date: Thu, 7 Jan 2010 14:16:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ian Molton <ian@mnementh.co.uk>
Subject: linux-next: manual merge of the mfd tree with the tmio-mmc tree
Message-Id: <20100107141613.62ca1bbd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jan_2010_14_16_13_+1100_nYEjKsL=LyAhk1Dq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jan_2010_14_16_13_+1100_nYEjKsL=LyAhk1Dq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got conflicts in
drivers/mfd/asic3.c, drivers/mfd/t7l66xb.c, drivers/mfd/tc6387xb.c,
drivers/mfd/tc6393xb.c, drivers/mfd/tmio_core.c,
drivers/mmc/host/tmio_mmc.c, drivers/mmc/host/tmio_mmc.h and
include/linux/mfd/tmio.h between commit
4cd83bd05e6c817a4a72ababd82bf5ae700c021d ("MMC: hardware abstraction for
CNF area") from the tmio-mmc tree and commit
b3df6513659704ece28da3b80cc36c2a8de315ce ("mfd: tmio_mmc hardware
abstraction for CNF area") from the mfd tree.

These are very similar patches, I used the version from the mfd tree as
that appears to be a later version.  Can you and Ian please sort this out
between you.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jan_2010_14_16_13_+1100_nYEjKsL=LyAhk1Dq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktFUf0ACgkQjjKRsyhoI8ynXACgly1yyExk+Zumo4xtix1ouADG
q9gAoLJqWj2nAgPIJYjes46nHJLgRWxw
=8l7M
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jan_2010_14_16_13_+1100_nYEjKsL=LyAhk1Dq--
