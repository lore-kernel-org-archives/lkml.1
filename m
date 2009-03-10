Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZCJLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZCJLIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZCJLH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:07:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54898 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZCJLH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:07:57 -0400
Date: Tue, 10 Mar 2009 22:07:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 10
Message-Id: <20090310220751.bd25139f.sfr@canb.auug.org.au>
In-Reply-To: <20090310093324.GA26779@infomag.iguana.be>
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
	<20090310093324.GA26779@infomag.iguana.be>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Mar_2009_22_07_51_+1100_O/Sq0+HKh5M3.mGz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Mar_2009_22_07_51_+1100_O/Sq0+HKh5M3.mGz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

On Tue, 10 Mar 2009 10:33:24 +0100 Wim Van Sebroeck <wim@iguana.be> wrote:
>
> > Merging watchdog/master
> > CONFLICT (content): Merge conflict in drivers/watchdog/orion5x_wdt.c
> > CONFLICT (content): Merge conflict in drivers/watchdog/rc32434_wdt.c
>=20
> I redid the linux-2.6-watchdog-next tree. Should be fixed next time.

Thanks.  I could see that they were just continuations of patches that
went into Linus' tree, so was not worried about them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Mar_2009_22_07_51_+1100_O/Sq0+HKh5M3.mGz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm2SgcACgkQjjKRsyhoI8xQ7wCfeqYn8VBaRO4GRD0dIn8vciDz
fQIAoJoC4rHXMIW6wvTdf9Y4wRi2ppke
=nSEn
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Mar_2009_22_07_51_+1100_O/Sq0+HKh5M3.mGz--
