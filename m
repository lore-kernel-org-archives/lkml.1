Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbYBOHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbYBOHcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764578AbYBOHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:31:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46496 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765031AbYBOHbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:31:52 -0500
Date: Fri, 15 Feb 2008 18:31:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 15
Message-Id: <20080215183143.c811803c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_18_31_43_+1100_po+z9oru.rDQm8BL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_18_31_43_+1100_po+z9oru.rDQm8BL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

Between each merge, the tree was built with allmodconfig for both
powerpc and x86_64.

You can see which trees have been included by looking in the Trees file
in the source.

The tree is now tagged with a tag like next-YYYYMMDD and has a
localversion-next file which adds "-next-YYYYMMDD" to the kernel revision.

There were a couple of merge conflicts and one build failure and the
appropriate people contacted.

We are up to 18 trees, more are welcome.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2008_18_31_43_+1100_po+z9oru.rDQm8BL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtT/oTgG2atn1QN8RAtBxAJ0dhsxpgw2jde+z3uJY+vdc48Vc4wCfflrF
NulmAX5D/ADwFyTVcN0i1/s=
=/FAR
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_18_31_43_+1100_po+z9oru.rDQm8BL--
