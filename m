Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYEMHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYEMHBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYEMHBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:01:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42202 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYEMHBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:01:12 -0400
Date: Tue, 13 May 2008 17:00:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Ralf Baechle <ralf@linux-mips.org>,
       Jan Kara <jack@ucw.cz>, Anton Vorontsov <cbou@mail.ru>,
       Jens Axboe <jens.axboe@oracle.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, Christian Zankel <chris@zankel.net>,
       Nicolas Pitre <nico@cam.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080513170052.eacecb02.sfr@canb.auug.org.au>
In-Reply-To: <20080513083615.4e463f87@mjolnir.drzeus.cx>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<20080513083615.4e463f87@mjolnir.drzeus.cx>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_May_2008_17_00_52_+1000_wqFqT239rBYU9UUz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_May_2008_17_00_52_+1000_wqFqT239rBYU9UUz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

On Tue, 13 May 2008 08:36:15 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wr=
ote:
>
> On Fri, 2 May 2008 15:12:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>=20
> >=20
> > git-mmc: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/drzeus/mm=
c.git#for-andrew
> >=20
>=20
> The stuff I've pushed to Andrew has always been what I've been hoping
> to merge in the next window, so it should just be a matter of renaming
> the branch. There is a #next at the above URI now.

I have added that for tomorrow, thanks.

I noticed that that tree also has a for-linus branch.  Would that be bug
fixes and stuff lined up for this release i.e. 2.6.26?  If so, I could
add that to linux-next as well as one of the early merge trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_May_2008_17_00_52_+1000_wqFqT239rBYU9UUz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKTysTgG2atn1QN8RArOmAJ91N2OSlxJ++pTVc8Oj0oteA1XctgCeN+q4
MLS6vQmdscXf1lawUtavSfU=
=x8W1
-----END PGP SIGNATURE-----

--Signature=_Tue__13_May_2008_17_00_52_+1000_wqFqT239rBYU9UUz--
