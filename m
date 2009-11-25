Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZKYHeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZKYHeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZKYHeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:34:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41179 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZKYHeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:34:16 -0500
Date: Wed, 25 Nov 2009 18:34:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the trivial tree with the ext4 tree
Message-Id: <20091125183414.eb45acca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_18_34_14_+1100_ZFaHcq43BLZjR0HE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_18_34_14_+1100_ZFaHcq43BLZjR0HE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
fs/ext4/balloc.c between commit 4433871130f36585fde38e7dd817433296648945
("ext4: fold ext4_free_blocks() and ext4_mb_free_blocks()") from the ext4
tree and commit 15dcf8433b514d1dc1b80d87a0798c2db2c37e95 ("tree-wide: fix
some typos and punctuation in comments") from the trivial tree.

The former moved the comment fixed by the latter and fixed the typo along
the way.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Nov_2009_18_34_14_+1100_ZFaHcq43BLZjR0HE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksM3fYACgkQjjKRsyhoI8zspwCeObyRQFS7p04musxPWRaFJnyq
GggAoMA8+H50/RFZxg5WvXEvy902yEiN
=pKyz
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_18_34_14_+1100_ZFaHcq43BLZjR0HE--
