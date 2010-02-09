Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0BIAHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:07:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0BIAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:07:15 -0500
Date: Tue, 9 Feb 2010 11:07:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <michal.simek@petalogix.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the microblaze tree with Linus' tree
Message-Id: <20100209110710.c7b6992b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Feb_2010_11_07_10_+1100_HO9Hfgp2pQybeTHz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Feb_2010_11_07_10_+1100_HO9Hfgp2pQybeTHz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the microblaze tree got a conflict in
arch/microblaze/kernel/setup.c between commit
a6013411118a6c8c34f1bd8b047b36fdf9711590 ("microblaze: Invalidate dcache
before enabling it") from Linus' tree and commit
578059c56c816db2b696a196d3656afc187c7edd ("microblaze: Move cache
function to cache.c") from the microblaze tree.

The microblaze tree version supercedes the version from Linus' tree, so I
used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Feb_2010_11_07_10_+1100_HO9Hfgp2pQybeTHz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwpy4ACgkQjjKRsyhoI8zuQwCeLXnZ5FALpbdwUr1fGd11V+yS
oWkAnjqGuNZG2jSbHaYmWHb2N5CzyPrI
=yawD
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Feb_2010_11_07_10_+1100_HO9Hfgp2pQybeTHz--
