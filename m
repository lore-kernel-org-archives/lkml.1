Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYCZGzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYCZGzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYCZGzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:55:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48580 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYCZGzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:55:05 -0400
Date: Wed, 26 Mar 2008 17:54:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 26
Message-Id: <20080326175459.234515bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_Mar_2008_17_54_59_+1100_pWUhjn/HScF2RIIn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Mar_2008_17_54_59_+1100_pWUhjn/HScF2RIIn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

There were a few merge conflicts (fairly trivial) and a couple of build
failures that have been notified.

We are up to 49 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests is at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ and the guys at http://test.kernel.org/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Mar_2008_17_54_59_+1100_pWUhjn/HScF2RIIn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH6fNHTgG2atn1QN8RAsJFAKCG/k7YbFomDpL+BdQb+yVYZU6iMgCeLYbQ
GKvo9ycxJ73RE7dHoqgShtE=
=Tau+
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Mar_2008_17_54_59_+1100_pWUhjn/HScF2RIIn--
