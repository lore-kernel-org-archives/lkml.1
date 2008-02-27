Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbYB0GDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbYB0GDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYB0GDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:03:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41806 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYB0GDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:03:07 -0500
Date: Wed, 27 Feb 2008 17:03:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 27
Message-Id: <20080227170300.25c50fe3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Feb_2008_17_03_00_+1100_4Etyx8K/3BiMKtAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2008_17_03_00_+1100_4Etyx8K/3BiMKtAN
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

There was only one minor merge problem and one build problem.

We are up to 35 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.

Also, the linux-next tree is being build/boot tested by the guys at
test.kernel.org.  Thanks to them.

This release has one already known build problem:  CONFIG_NFS_FS && !
CONFIG_NFS_V4 will fail to build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Feb_2008_17_03_00_+1100_4Etyx8K/3BiMKtAN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxP0ZTgG2atn1QN8RAj+AAJ9rSQ6sxENU9wEgHnihpMi4XnYDtQCglTy3
yqZ4coYb+y8YRH4gDTXDSVc=
=c1UR
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2008_17_03_00_+1100_4Etyx8K/3BiMKtAN--
