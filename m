Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbYBVGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbYBVGEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYBVGE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:04:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYBVGE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:04:28 -0500
Date: Fri, 22 Feb 2008 17:04:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 22
Message-Id: <20080222170421.9e17d143.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Feb_2008_17_04_21_+1100_/SGd_qXwIt2rWwvS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2008_17_04_21_+1100_/SGd_qXwIt2rWwvS
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

There only one merge problem and no build failures!

We are up to 30 trees, more are welcome (even if they are currently
empty).  I would encourage architecture maintainers, in particular, to
set up a git branch or quilt tree now to avoid the rush after RC3 :-)

I am now including tarballs in
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/.

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  The sparc builds have
been mostly disabled while I obtain a working cross compiler.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Feb_2008_17_04_21_+1100_/SGd_qXwIt2rWwvS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvmXpTgG2atn1QN8RAl/WAKCI+zZjywQiH+GUXZQ4V6V2GvWZjgCdHSEv
DP6l2rXYQe9nd9T5ddjtUkY=
=G4Gv
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2008_17_04_21_+1100_/SGd_qXwIt2rWwvS--
