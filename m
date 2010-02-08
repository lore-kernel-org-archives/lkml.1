Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0BHEsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 23:48:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42566 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab0BHEsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 23:48:37 -0500
Date: Mon, 8 Feb 2010 15:48:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the trivial tree with the arm tree
Message-Id: <20100208154831.adebe731.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_15_48_31_+1100_yIsC66a4cSAMSM4Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_15_48_31_+1100_yIsC66a4cSAMSM4Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/plat-s3c64xx/irq.c between commit
51022cf6591ae2945960d034788bdeffa28cde13 ("ARM: SAMSUNG: Move IRQ UART
handling for newer devices to plat-samsung") from the arm tree and commit
ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
fixes") from the trivial tree.

The former removes the comment updated by the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Feb_2010_15_48_31_+1100_yIsC66a4cSAMSM4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktvl58ACgkQjjKRsyhoI8xFjQCgrRCvzIuDCfjf8Aiy+ZQUjY/8
QM0An1Dp1L3oWza8BwexbHy4DKUZ58pN
=AdtF
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_15_48_31_+1100_yIsC66a4cSAMSM4Q--
