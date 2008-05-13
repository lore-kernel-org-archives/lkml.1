Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYEMMeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYEMMeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYEMMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:33:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55902 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYEMMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:33:55 -0400
Date: Tue, 13 May 2008 22:33:40 +1000
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
Message-Id: <20080513223340.de2bb4a4.sfr@canb.auug.org.au>
In-Reply-To: <20080513124745.24158a93@mjolnir.drzeus.cx>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<20080513083615.4e463f87@mjolnir.drzeus.cx>
	<20080513170052.eacecb02.sfr@canb.auug.org.au>
	<20080513124745.24158a93@mjolnir.drzeus.cx>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_May_2008_22_33_40_+1000_Tp2GAvzg1aj9xd=H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_May_2008_22_33_40_+1000_Tp2GAvzg1aj9xd=H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

On Tue, 13 May 2008 12:47:45 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wr=
ote:
>
> That's correct. But I've always made sure that for-linus is the base for
> for-andrew (now next), so that should not be necessary.

What it allows me to do, though, is drop your "next" tree if things go
really bad without dropping fixes for Linus' current tree that you deem
necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_May_2008_22_33_40_+1000_Tp2GAvzg1aj9xd=H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKYqrTgG2atn1QN8RAkyVAJsEkNxMvuyM+qe6UdmcbKRBMkMSmgCePHC8
jnyYOD+pXwAdXKn/1e8wnKo=
=pQxf
-----END PGP SIGNATURE-----

--Signature=_Tue__13_May_2008_22_33_40_+1000_Tp2GAvzg1aj9xd=H--
