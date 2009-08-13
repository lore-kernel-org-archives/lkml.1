Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZHMEEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZHMEEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZHMEEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:04:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47927 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZHMEEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:04:23 -0400
Date: Thu, 13 Aug 2009 14:04:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, peterz@infradead.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
       jengelh@medozas.de
Subject: Re: linux-next: manual merge of the tip tree with the net tree
Message-Id: <20090813140407.1a9a909c.sfr@canb.auug.org.au>
In-Reply-To: <20090812.173325.255498124.davem@davemloft.net>
References: <20090807164705.725869c1.sfr@canb.auug.org.au>
	<20090812.173325.255498124.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Aug_2009_14_04_07_+1000__1PkpSS2Li4I2pBu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Aug_2009_14_04_07_+1000__1PkpSS2Li4I2pBu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 12 Aug 2009 17:33:25 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 7 Aug 2009 16:47:05 +1000
>=20
> > Today's linux-next merge of the tip tree got a conflict in
> > arch/x86/include/asm/socket.h between commits
> > 49c794e94649020248e37b78db16cd25bad38b4f ("net: implement a SO_PROTOCOL
> > getsockoption") and 0d6038ee76f2e06b79d0465807f67e86bf4025de ("net:
> > implement a SO_DOMAIN getsockoption") from the net tree and commit
> > 73a2d096fdf23aa841f7595d114a11ec85a85e4d ("x86: remove all now-duplicate
> > header files") from the tip tree.
> >=20
> > The latter change supercedes the former ones, so I used the latter.
>=20
> That should be the correct merge resolution, thanks!

OK, thanks for the confirmation.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Aug_2009_14_04_07_+1000__1PkpSS2Li4I2pBu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqDkLcACgkQjjKRsyhoI8wN6QCfYQmL8dVBweeD52mf50I4fkqx
ovkAoIM6m1h5CKvO8Bf7aXhMUNlMiY77
=gK1s
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Aug_2009_14_04_07_+1000__1PkpSS2Li4I2pBu--
