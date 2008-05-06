Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYEFElo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYEFElo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYEFElf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:41:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYEFEle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:41:34 -0400
Date: Tue, 6 May 2008 14:41:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, stefanr@s5r6.in-berlin.de,
       jeff@garzik.org, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, clameter@sgi.com,
       ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080506144111.43736d63.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com>
	<20080505113128.d68863a2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805052136530.5570@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_14_41_11_+1000_56L45qrB8aHu=eFW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_14_41_11_+1000_56L45qrB8aHu=eFW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pekka,

On Mon, 5 May 2008 21:41:53 +0300 (EEST) Pekka J Enberg <penberg@cs.helsink=
i.fi> wrote:
>
> Well, I only really have three kinds of patches: (1) testing, (2)=20
> for-linus asap (fixes in the middle of a release cycle) and (3) for-linus=
=20
> when the merge window opens. Up until now, I've put (1) in for-mm and=20
> after enough exposure (and no bug reports) they graduate into (2) or (3).
>=20
> So the problem here is where I put the patches in category (1)? If=20
> they can go into for-next, then for-mm can disappear. Stephen?

Stefan Richter is right: if they have passed your review and testing in
isolation, then they are allowed into -next for testing against other
subsystems. So (2), (3), and (1b) ... :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_14_41_11_+1000_56L45qrB8aHu=eFW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH+FwTgG2atn1QN8RArC+AJ0WkPw6xLKyt/N2xAcfuxZeHTznGQCgg6tG
DLeEjgOiJRbirJd1TMSE0Bs=
=XO82
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_14_41_11_+1000_56L45qrB8aHu=eFW--
