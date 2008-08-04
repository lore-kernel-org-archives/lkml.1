Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYHDFre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYHDFre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYHDFrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:47:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYHDFrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:47:24 -0400
Date: Mon, 4 Aug 2008 15:47:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-Id: <20080804154717.cfdb6710.sfr@canb.auug.org.au>
In-Reply-To: <20080730231029.9818953c.akpm@linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
	<20080730231029.9818953c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Aug_2008_15_47_17_+1000_ndiXz4hh.vR59FiU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Aug_2008_15_47_17_+1000_ndiXz4hh.vR59FiU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Dmitry,

On Wed, 30 Jul 2008 23:10:29 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 30 Jul 2008 17:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>=20
> The X server broke on my FC8 t61p thinkpad.  Mainline is OK.
>=20
> Various information is at http://userweb.kernel.org/~akpm/mo/
>=20
> I'm suspecting the input layer - my synaptics device seems to have
> disappeared?  See http://userweb.kernel.org/~akpm/mo/Xorg-log-diff.txt

I have reverted commit 03bac96fae0efdb25e2059e5accbe4f3ee6328dd ("Input:
expand keycode space") from linux-next until we have some resolution of
this problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Aug_2008_15_47_17_+1000_ndiXz4hh.vR59FiU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiWl+UACgkQjjKRsyhoI8wjmQCeMU1gFz7Ghksk3x2cS467FEUh
ajUAn2a+k/1zjQkzaapO5v0ArarZuo1A
=+Hcp
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Aug_2008_15_47_17_+1000_ndiXz4hh.vR59FiU--
