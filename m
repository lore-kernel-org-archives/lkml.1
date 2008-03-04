Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYCDLkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYCDLkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYCDLj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:39:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55891 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYCDLjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:39:55 -0500
Date: Tue, 4 Mar 2008 22:39:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 4
Message-Id: <20080304223947.375be10b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Mar_2008_22_39_47_+1100_REOwXT=xF5fyU442"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2008_22_39_47_+1100_REOwXT=xF5fyU442
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

We are up to 40 trees, more are welcome (even if they are currently
empty).  The influx of new trees has been underwhelming.  Thanks to those
who have contributed, and to those who haven't, please do.

Status of my local build tests is at
http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
give advice about cross compilers/configs that work, we are always open
to add more builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Mar_2008_22_39_47_+1100_REOwXT=xF5fyU442
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzTUJTgG2atn1QN8RAvgrAJ0QZSVhqZ223NkhIKvPIQtACbd4VACeLKEp
viTH+pg29iNch9S6cknrIl0=
=yTVy
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2008_22_39_47_+1100_REOwXT=xF5fyU442--
