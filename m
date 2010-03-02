Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0CBXiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:38:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47167 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0CBXiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:38:15 -0500
Date: Wed, 3 Mar 2010 10:38:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Peter Osterlund <petero2@telia.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH -next] pktcdvd: improve BKL and compat_ioctl.c usage
Message-Id: <20100303103810.02c2fd63.sfr@canb.auug.org.au>
In-Reply-To: <20100302120621.GA28192@elte.hu>
References: <20100225183523.80361261.sfr@canb.auug.org.au>
	<4B86B97D.6030208@oracle.com>
	<201002252227.11472.arnd@arndb.de>
	<4B86F564.9000105@oracle.com>
	<20100302120621.GA28192@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_10_38_10_+1100_mpWPe=6yuYl9unu/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_10_38_10_+1100_mpWPe=6yuYl9unu/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 2 Mar 2010 13:06:21 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> FYI, this build bug now triggers upstream too - none of the fixes was app=
lied.

Thanks again, I have put Arnd's patch in my fixes as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_10_38_10_+1100_mpWPe=6yuYl9unu/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuNoWIACgkQjjKRsyhoI8zhxQCaAgMpyGDCUqFGS9TRAXtz0hhx
7Y0An1pq6l1CO7PkazvY8HhB+Unt9E1U
=DMGq
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_10_38_10_+1100_mpWPe=6yuYl9unu/--
