Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYBRII4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYBRII4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYBRIIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:08:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43844 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYBRIIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:08:48 -0500
Date: Mon, 18 Feb 2008 19:08:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 18
Message-Id: <20080218190841.eeed735f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Feb_2008_19_08_41_+1100_R_Y7sFpy8SihYhid"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2008_19_08_41_+1100_R_Y7sFpy8SihYhid
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

The tree is now tagged with a tag like next-YYYYMMDD and has a
localversion-next file which adds "-next-YYYYMMDD" to the kernel revision.

There were a couple of merge conflicts and a couple of build failures and
the appropriate people contacted.

We are up to 24 trees, more are welcome.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Feb_2008_19_08_41_+1100_R_Y7sFpy8SihYhid
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuT0OTgG2atn1QN8RAvtKAJ0VjrmGhHhY1D+o0fhd86Fg1qo8ngCfV+4o
O3c3rRUEpOfkoQFmqsjvoK8=
=0PhT
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2008_19_08_41_+1100_R_Y7sFpy8SihYhid--
