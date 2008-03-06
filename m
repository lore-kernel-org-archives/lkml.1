Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbYCFF0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbYCFF0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYCFF0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:26:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35971 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbYCFF0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:26:18 -0500
Date: Thu, 6 Mar 2008 16:26:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 6
Message-Id: <20080306162606.970aefe1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Mar_2008_16_26_06_+1100_orPmswX.Fg30zZ2="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2008_16_26_06_+1100_orPmswX.Fg30zZ2=
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
allmodconfig for both powerpc and x86_64.

There were a few merge conflicts (trivial) and one build break.  I have
notified the appropriate people.

We are up to 44 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2008_16_26_06_+1100_orPmswX.Fg30zZ2=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHz4B3TgG2atn1QN8RAj0lAKCHGHCJ4m/I3WIurEEjthr4wrpfWgCfZ6Wt
23UA8sHv/Kqbu1TdfSWwzSA=
=pfbi
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2008_16_26_06_+1100_orPmswX.Fg30zZ2=--
