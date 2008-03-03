Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYCCGGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYCCGGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYCCGGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:06:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40161 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYCCGGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:06:31 -0500
Date: Mon, 3 Mar 2008 17:06:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 3
Message-Id: <20080303170612.65e60b99.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_Mar_2008_17_06_12_+1100_FRIDLaaaXKzOyA.w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2008_17_06_12_+1100_FRIDLaaaXKzOyA.w
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

There were three minor merge problems.

We are up to 39 trees, more are welcome (even if they are currently
empty).

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2008_17_06_12_+1100_FRIDLaaaXKzOyA.w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHy5VjTgG2atn1QN8RAhVwAJ4025VlHqsB+cvr+APjV6Z8P999lgCdGV49
lR4CDPlg9Vt6qCnNQjcg/W4=
=vrQ2
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2008_17_06_12_+1100_FRIDLaaaXKzOyA.w--
