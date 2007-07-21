Return-Path: <linux-kernel-owner+w=401wt.eu-S936039AbXGUPs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936039AbXGUPs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXGUPsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:48:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55017 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbXGUPsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:48:19 -0400
Date: Sun, 22 Jul 2007 01:48:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Boutcher <boutcher@us.ibm.com>, Ryan Arnold <ryanarn@us.ibm.com>,
       Colin Devilbiss <devilbis@us.ibm.com>,
       Stephen Rothwell <sfr@au1.ibm.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH][05/37] Clean up duplicate includes in drivers/block/
Message-Id: <20070722014823.f093a362.sfr@canb.auug.org.au>
In-Reply-To: <200707211701.53199.jesper.juhl@gmail.com>
References: <200707211701.53199.jesper.juhl@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__22_Jul_2007_01_48_23_+1000_a489aC1VSeQCf_8C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2007_01_48_23_+1000_a489aC1VSeQCf_8C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jul 2007 17:01:52 +0200 Jesper Juhl <jesper.juhl@gmail.com> wrot=
e:
>
> Hi,
>=20
> This patch cleans up duplicate includes in
> 	drivers/block/
>=20
>=20
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__22_Jul_2007_01_48_23_+1000_a489aC1VSeQCf_8C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoirNTgG2atn1QN8RAhayAJ9rDrwhfljVgwspmJ6h9Z+D0Oik/ACfWFfP
Eh9Ts5gNvt+uAHijh1TcXa8=
=MVqB
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2007_01_48_23_+1000_a489aC1VSeQCf_8C--
