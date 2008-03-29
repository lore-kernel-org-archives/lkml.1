Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbYC2LeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbYC2LeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 07:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYC2LeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 07:34:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYC2LeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 07:34:10 -0400
Date: Sat, 29 Mar 2008 22:33:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 29
Message-Id: <20080329223354.304e2722.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__29_Mar_2008_22_33_54_+1100_Yki+4N4gxZB/52Eo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__29_Mar_2008_22_33_54_+1100_Yki+4N4gxZB/52Eo
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

There were a few merge conflicts (fairly trivial).

People might like to check up in the (post-creation) build failures at
http://kisskb.ellerman.id.au/linux-next, there are quite a few more than
usual.  I'll try to figure out what went wrong tomorrow unless you all
beat me to it.

We are up to 50 trees, more are welcome (even if they are currently
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

--Signature=_Sat__29_Mar_2008_22_33_54_+1100_Yki+4N4gxZB/52Eo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH7ikwTgG2atn1QN8RAgSGAJsHYSsdmn+OTIx/9RjJ/ciO4NwRSQCghyYz
BTov9GwzBgZ8HJgklMj0SRs=
=KPbA
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Mar_2008_22_33_54_+1100_Yki+4N4gxZB/52Eo--
