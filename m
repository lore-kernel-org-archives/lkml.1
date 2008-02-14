Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbYBNOmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbYBNOmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYBNOmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:42:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40733 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbYBNOmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:42:21 -0500
Date: Fri, 15 Feb 2008 01:42:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alasdair G Kergon <agk@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: linux-next: quilt series
Message-Id: <20080215014210.73c71078.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Feb_2008_01_42_10_+1100_aH=QNjWU7p4kGI=3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2008_01_42_10_+1100_aH=QNjWU7p4kGI=3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

To make my life easier, can I ask that the series file for any quilt trees =
in the linux-next tree have a comment at the top to identify their base (ei=
ther a SHA1 or some other ref in Linus' tree).  Like this:

# BASE <SHA1 or ref>

Also, if you only want a subset of the series file included, you can mark t=
he patches with

# NEXT_PATCHES_START
	.
	.
# NEXT_PATCHES_END

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Feb_2008_01_42_10_+1100_aH=QNjWU7p4kGI=3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtFNMTgG2atn1QN8RAsttAJkBzOgDVxhQ63ErH5dR5a92nZmMbgCfZZgA
13u+MSZh/tKKgt12NrruBNo=
=N5JL
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2008_01_42_10_+1100_aH=QNjWU7p4kGI=3--
