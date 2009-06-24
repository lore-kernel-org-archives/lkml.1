Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZFXHrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZFXHrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFXHrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:47:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZFXHrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:47:01 -0400
Date: Wed, 24 Jun 2009 17:46:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: Main things left in linux-next
Message-Id: <20090624174657.c325f500.sfr@canb.auug.org.au>
In-Reply-To: <84144f020906240040ycf40bd6q20af82907315adc2@mail.gmail.com>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au>
	<20090624172735.9b500674.sfr@canb.auug.org.au>
	<84144f020906240040ycf40bd6q20af82907315adc2@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Jun_2009_17_46_57_+1000_NPnVhYRY/GFckm9g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jun_2009_17_46_57_+1000_NPnVhYRY/GFckm9g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pekka,

On Wed, 24 Jun 2009 10:40:48 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wr=
ote:
>
> 2009/6/24 Stephen Rothwell <sfr@canb.auug.org.au>:
> > The main obvious things left are:
> >
> > SLQB from the slab tree
>=20
> This didn't make it to 2.6.31. Do you want me to drop it until -rc1 is ou=
t?

At this point, it hardly matters as I suspect -rc1 will be in the next
day or so.  Probably better to keep things stable for Andrew, so leave it
in, I guess.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Jun_2009_17_46_57_+1000_NPnVhYRY/GFckm9g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpB2fEACgkQjjKRsyhoI8zYRwCgtM1Fx0m+JYshCKl1fWkN/VJH
9SkAniWTHqACLp+bJNslefow0ASCIoUN
=vxAV
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jun_2009_17_46_57_+1000_NPnVhYRY/GFckm9g--
