Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbYB2MRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbYB2MRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYB2MRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:17:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50436 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYB2MRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:17:08 -0500
Date: Fri, 29 Feb 2008 23:17:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: linux-next: semaphore update merge conflicts
Message-Id: <20080229231704.112d8112.sfr@canb.auug.org.au>
In-Reply-To: <20080229111731.13840877@hskinnemoen.norway.atmel.com>
References: <20080229153958.fc34e281.sfr@canb.auug.org.au>
	<20080229111731.13840877@hskinnemoen.norway.atmel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_23_17_04_+1100_vknRUyQ2/kFMSYx9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_23_17_04_+1100_vknRUyQ2/kFMSYx9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Feb 2008 11:17:31 +0100 Haavard Skinnemoen <hskinnemoen@atmel.co=
m> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > 	arch/avr32/kernel/semaphore.c
> > 		the avr32 tree appeared to just change spaces to tabs
> > 		in this file so I removed it (as your changes did).
>=20
> I yanked that change out of my tree. No point cleaning up that file if
> it's going away.

OK, thanks.

By the way, is there some place I can get a cross compiler to build avr32
kernels (or better yet a recipe for crosstool to make one)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Feb_2008_23_17_04_+1100_vknRUyQ2/kFMSYx9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx/fFTgG2atn1QN8RAgHKAJ0bmNfReinSub0dKsZL5cY4RWKHmQCeL19K
6DCMQ+7ZzmIpMIuKywSJcjM=
=tAUy
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_23_17_04_+1100_vknRUyQ2/kFMSYx9--
