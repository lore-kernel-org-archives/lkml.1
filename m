Return-Path: <linux-kernel-owner+w=401wt.eu-S1764440AbYCEJr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764440AbYCEJr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbYCEJrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:47:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbYCEJrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:47:15 -0500
Date: Wed, 5 Mar 2008 20:47:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 5
Message-Id: <20080305204708.6834c627.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Mar_2008_20_47_08_+1100_ICg_luPe6qrWB_Fh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2008_20_47_08_+1100_ICg_luPe6qrWB_Fh
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

There was one quilt import problem, a few merge conflicts (trivial) and a
couple of build breaks.  I have notified the appropriate people.

We are up to 42 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2008_20_47_08_+1100_ICg_luPe6qrWB_Fh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzmwhTgG2atn1QN8RAio7AJ9exPvAa6zkGQWNoY26seDMI4z1DACgkwSU
A4NcDo4mY6EJimkG4DKW22U=
=YNfW
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2008_20_47_08_+1100_ICg_luPe6qrWB_Fh--
