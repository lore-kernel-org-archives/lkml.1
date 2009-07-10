Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZGJBUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZGJBUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZGJBUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:20:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZGJBUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:20:38 -0400
Date: Fri, 10 Jul 2009 11:20:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: ttydev tree import failure
Message-Id: <20090710112032.d424b4e8.sfr@canb.auug.org.au>
In-Reply-To: <20090710013411.32a68454@lxorguk.ukuu.org.uk>
References: <20090710091408.67c4da53.sfr@canb.auug.org.au>
	<20090710004743.202b36e5@lxorguk.ukuu.org.uk>
	<20090710013411.32a68454@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jul_2009_11_20_32_+1000_qhD98nAdILv9lZYR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jul_2009_11_20_32_+1000_qhD98nAdILv9lZYR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jul 2009 01:34:11 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> Fixed - chuckle
>=20
> the right patch was there but I forgot to remove the original patch which
> for some reason stgit didn't import properly so you had both in the file.
> Will push that tomorrow.

OK, thanks.  Aren't tools wonderful sometimes?  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Jul_2009_11_20_32_+1000_qhD98nAdILv9lZYR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpWl2AACgkQjjKRsyhoI8zdpQCdHpEM3QZGfqhd4q6UGhIw/bjX
5lAAoJH0S9wclIBDbVTjxjvlfr2nRkRe
=tBIK
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jul_2009_11_20_32_+1000_qhD98nAdILv9lZYR--
