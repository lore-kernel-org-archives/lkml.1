Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZKIDmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZKIDmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZKIDmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:42:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51027 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZKIDmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:42:22 -0500
Date: Mon, 9 Nov 2009 14:42:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: linux-next: manual merge of the pcmcia tree with the mtd tree
Message-Id: <20091109144221.f27d7242.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_14_42_21_+1100_+mm81Ncy9Jy7gnXR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_14_42_21_+1100_+mm81Ncy9Jy7gnXR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

Today's linux-next merge of the pcmcia tree got a conflict in
drivers/mtd/maps/pcmciamtd.c between commit
5da6bbe2f9e1db56b4a94cad2ace7d9992b1d666 ("pcmcia: convert pcmciamtd
driver to use new CIS helpers") from the mtd tree and commit
18b61b97294dad74dd00a1aa8efed0cfacb95aff ("pcmcia: convert pcmciamtd
driver to use new CIS helpers") from the pcmcia tree.

Presumably two different versions of the same change?  I just used the
version from the pcmcia tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_14_42_21_+1100_+mm81Ncy9Jy7gnXR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3j50ACgkQjjKRsyhoI8ySLgCfWxoLcjJjocKa01dIi99qKpsf
bw0An3E57X9zd3LdPM01/pXTNk+mpKAR
=5nBT
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_14_42_21_+1100_+mm81Ncy9Jy7gnXR--
