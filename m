Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYGYHOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYGYHOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYGYHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:14:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55020 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYGYHOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:14:08 -0400
Date: Fri, 25 Jul 2008 17:13:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Let HP iLO driver depend on PCI
Message-Id: <20080725171351.1bd3aa9d.sfr@canb.auug.org.au>
In-Reply-To: <20080724231519.b4553fa1.akpm@linux-foundation.org>
References: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
	<20080724215652.24e4e550.akpm@linux-foundation.org>
	<20080725153502.283aae1f.sfr@canb.auug.org.au>
	<20080724231519.b4553fa1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jul_2008_17_13_51_+1000_z.kR319KXV7Mleqw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jul_2008_17_13_51_+1000_z.kR319KXV7Mleqw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 24 Jul 2008 23:15:19 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Wow, lots of red.

Yeah :-(

> May I revise my comment?  Three weeks and nobody did anything about the
> failing allmodconfig builds on linux-next and s390 (at least).
>=20
> Is anyone actively monitoring that page and doing the requisite culprit-p=
oking?

I should do more - I do most days look for new things.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jul_2008_17_13_51_+1000_z.kR319KXV7Mleqw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiJfS8ACgkQjjKRsyhoI8yuYACdFmUiLUoXViD/5oLjWCW7KEKS
kzgAn2RL6JTEXo0iiWoo/r32quYzXPFL
=ANKc
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jul_2008_17_13_51_+1000_z.kR319KXV7Mleqw--
