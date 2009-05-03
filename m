Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZECKmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZECKmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 06:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZECKm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 06:42:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41634 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZECKm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 06:42:26 -0400
Date: Sun, 3 May 2009 20:42:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jean Delvare <khali@linux-fr.org>, Anders Kaseorg <andersk@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-Id: <20090503204218.6c65c740.sfr@canb.auug.org.au>
In-Reply-To: <20090503103010.GA27978@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare>
	<20090503103010.GA27978@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__3_May_2009_20_42_18_+1000_LLeVdtli_j47+=ZL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__3_May_2009_20_42_18_+1000_LLeVdtli_j47+=ZL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Sun, 3 May 2009 12:30:10 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Cannot reproduce here..
>=20
> Can you send me your config so I can try to see if this is toolchain
> version related.
>=20
> Also what version of gcc/binutils are you using?
> Is this x86 and 32/64 bit?

We have a similar report on PowerPC
http://ozlabs.org/pipermail/linuxppc-dev/2009-May/071629.html

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__3_May_2009_20_42_18_+1000_LLeVdtli_j47+=ZL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn9dQoACgkQjjKRsyhoI8zznQCgvtxp9K6ifj7zQpO3aAQOavxa
MHYAn3lAf0auMBFZAkvqMMRo3IrPpCwL
=6HWJ
-----END PGP SIGNATURE-----

--Signature=_Sun__3_May_2009_20_42_18_+1000_LLeVdtli_j47+=ZL--
