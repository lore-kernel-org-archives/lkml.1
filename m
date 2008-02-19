Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYBSHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYBSHij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbYBSHib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:38:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44151 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYBSHia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:38:30 -0500
Date: Tue, 19 Feb 2008 18:38:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 19
Message-Id: <20080219183825.1c71c9b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Feb_2008_18_38_25_+1100_tfLhtywO+un4stiJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Feb_2008_18_38_25_+1100_tfLhtywO+un4stiJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
allmodconfig for both powerpc and x86_64.

There were a couple of merge conflicts and a couple of build failures and
the appropriate people contacted.

We are up to 26 trees, more are welcome (even if they are currently empty).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Feb_2008_18_38_25_+1100_tfLhtywO+un4stiJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuod1TgG2atn1QN8RAsReAKCFDZAKWIsG1iFifU9ZCRyJAbL6qwCgk6ra
V92DgfZisdh2VMb0xRDYg88=
=gSDO
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Feb_2008_18_38_25_+1100_tfLhtywO+un4stiJ--
