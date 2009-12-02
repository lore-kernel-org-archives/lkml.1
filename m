Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZLBWZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZLBWZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZLBWZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:25:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37901 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbZLBWZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:25:25 -0500
Date: Thu, 3 Dec 2009 09:25:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-Id: <20091203092525.17d939b3.sfr@canb.auug.org.au>
In-Reply-To: <20091202115649.GA2150@rainbow>
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au>
	<20091202115649.GA2150@rainbow>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Dec_2009_09_25_25_+1100_M7a8u2=uBOULkMss"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Dec_2009_09_25_25_+1100_M7a8u2=uBOULkMss
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Wed, 2 Dec 2009 14:56:49 +0300 Dmitry Artamonow <mad_soft@inbox.ru> wrot=
e:
>
> Fix looks good to me, and testing next-20091201 on real device (h3600)
> shows no problems with pcmcia.

Thanks for the confirmation.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Dec_2009_09_25_25_+1100_M7a8u2=uBOULkMss
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksW6VUACgkQjjKRsyhoI8xj+ACfdkbwiC6FLkpfcOPQRG8JvpRo
cKAAoKEvjBiqKtvs0bca59ljrv1jz9M0
=iV7l
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Dec_2009_09_25_25_+1100_M7a8u2=uBOULkMss--
