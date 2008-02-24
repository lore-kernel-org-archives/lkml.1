Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYBXFXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYBXFXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYBXFXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:23:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37319 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYBXFXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:23:15 -0500
Date: Sun, 24 Feb 2008 16:23:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 24
Message-Id: <20080224162309.3e67dd22.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__24_Feb_2008_16_23_09_+1100_I3rlZEvOjNn_8t=e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__24_Feb_2008_16_23_09_+1100_I3rlZEvOjNn_8t=e
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

There only one minor merge problem and a few build failures (the two in
Linus' tree have been fixed and the other reported).

We are up to 32 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__24_Feb_2008_16_23_09_+1100_I3rlZEvOjNn_8t=e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwP9CTgG2atn1QN8RAgoUAJ9PSGHy51aKh0Xwz9hJ1cRq8K8BKACfUxIN
P5+OF0Pq40U34DboG73gN7Q=
=hnVz
-----END PGP SIGNATURE-----

--Signature=_Sun__24_Feb_2008_16_23_09_+1100_I3rlZEvOjNn_8t=e--
