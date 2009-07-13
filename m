Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZGMCu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZGMCu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZGMCuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:50:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35616 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZGMCuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:50:22 -0400
Date: Mon, 13 Jul 2009 12:50:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Kilroy <kilroyd@googlemail.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: linux-next: manual merge of the net tree with the  tree
Message-Id: <20090713125015.c3024be8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Jul_2009_12_50_15_+1000_e2Dl.Q6ZO4hCGQEP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jul_2009_12_50_15_+1000_e2Dl.Q6ZO4hCGQEP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/orinoco/main.c between commit
240c102d9c54fee7fdc87a4ef2fabc7eb539e00a ("netdev: restore MAC address
set and validate operations") from the net-current tree and
commit5381956b780e82805247c2ec8e32c4c665309394 ("orinoco: move netdev
interface creation to main driver") from the net tree.

Just overlapping removals.  I fixed it up and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Jul_2009_12_50_15_+1000_e2Dl.Q6ZO4hCGQEP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpaoOcACgkQjjKRsyhoI8zVGgCfT4rg4dFTcYM92nBDChaJDojR
7fUAn1WRB7clvEFMDH5muDh6ufCy0TCc
=Z3Y0
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jul_2009_12_50_15_+1000_e2Dl.Q6ZO4hCGQEP--
