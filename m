Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYBYGb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYBYGb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYBYGbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:31:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43576 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbYBYGbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:31:17 -0500
Date: Mon, 25 Feb 2008 17:31:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 24
Message-Id: <20080225173100.b539ac2d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Feb_2008_17_31_00_+1100_4uQ05rp/D25iOgSS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2008_17_31_00_+1100_4uQ05rp/D25iOgSS
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

There were only two minor merge problems.

We are up to 33 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Feb_2008_17_31_00_+1100_4uQ05rp/D25iOgSS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwmC0TgG2atn1QN8RAkB9AJ4ntOtBmiFWA0eFt1aezx1zSqQ9bQCgkTzf
sP6ivSBQsEqXq5phzJ+1tY4=
=nYEj
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2008_17_31_00_+1100_4uQ05rp/D25iOgSS--
