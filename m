Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0BHEsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 23:48:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42540 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0BHEsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 23:48:17 -0500
Date: Mon, 8 Feb 2010 15:48:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       Yoichi Yuasa <yuasa@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20100208154808.b5670cd5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_15_48_08_+1100_sdRN=S6Zp29rUAk/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_15_48_08_+1100_sdRN=S6Zp29rUAk/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/mips/alchemy/common/reset.c between commit
139047ceae71916626ee36bea9ef35f1030aabfe ("MIPS: Alchemy: get rid of
common/reset.c") from the  tree and commit
ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
fixes") from the trivial tree.

The former removes the file updated by the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Feb_2010_15_48_08_+1100_sdRN=S6Zp29rUAk/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktvl4gACgkQjjKRsyhoI8wu3QCgvY9T91/0lPDMYbPkIPRHH//V
/5kAn0bbEVyIpuxWehzLwEOWw/ZQeHqA
=5fUs
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_15_48_08_+1100_sdRN=S6Zp29rUAk/--
