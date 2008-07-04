Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbYGDObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbYGDObV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYGDObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:31:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbYGDObD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:31:03 -0400
Date: Sat, 5 Jul 2008 00:30:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: next-0704: x86_64 panics on booting
Message-Id: <20080705003048.30dcb64a.sfr@canb.auug.org.au>
In-Reply-To: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
References: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Jul_2008_00_30_48_+1000_2G8V07Jy5Vertgew"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Jul_2008_00_30_48_+1000_2G8V07Jy5Vertgew
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

On Fri, 4 Jul 2008 18:20:47 +0400 "Alexander Beregalov" <a.beregalov@gmail.=
com> wrote:
>
> Booting the kernel.
>=20
> Kernel alive
> Kernel really alive
> PANIC: early exception 0e rip 10:ffffffff80604f47 error 2 cr2 ffffffffff3=
00000
>=20
> It is x86_64 SMP (opteron).

Config?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Jul_2008_00_30_48_+1000_2G8V07Jy5Vertgew
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhuNBgACgkQjjKRsyhoI8zRtACghXdW3sn8BrCYg6Bg/wadXk55
NYAAn1wsLceH20asMFM4pdADZDrMzpFb
=3GxG
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Jul_2008_00_30_48_+1000_2G8V07Jy5Vertgew--
