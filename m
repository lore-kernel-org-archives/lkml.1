Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0BVDN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 22:13:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44757 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab0BVDNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 22:13:54 -0500
Date: Mon, 22 Feb 2010 14:13:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>, David Miller <davem@davemloft.net>,
       Daniel Mack <daniel@caiaq.de>
Subject: linux-next: manual merge of the trivial tree with the sparc tree
Message-Id: <20100222141341.f5c92be4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_14_13_41_+1100_67DVQuCCUj8x=ubP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Feb_2010_14_13_41_+1100_67DVQuCCUj8x=ubP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/sparc/kernel/leon_kernel.c between commit
0da2b300b91ddeb9944c3fb4faaf78c1c482c0af ("sparc: remove trailing space
in messages") from the sparc tree and commit
3ad2f3fbb961429d2aa627465ae4829758bc7e07 ("tree-wide: Assorted spelling
fixes") from the trivial tree.

The former also fixed the spelling mistake fixed by the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Feb_2010_14_13_41_+1100_67DVQuCCUj8x=ubP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuB9mUACgkQjjKRsyhoI8yx6ACgqQdqdK5iN6962aBur8gklv+P
G6sAoIh8hY4eodFSCUiBl+73C1Ntqc/e
=sKur
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_14_13_41_+1100_67DVQuCCUj8x=ubP--
