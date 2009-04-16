Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZDPIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZDPIgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZDPIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:35:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33240 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZDPIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:35:51 -0400
Date: Thu, 16 Apr 2009 18:35:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, Johannes Weiner <jw@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Xtensa patches
Message-Id: <20090416183543.d60521e6.sfr@canb.auug.org.au>
In-Reply-To: <20090416012447.fd6e6dee.akpm@linux-foundation.org>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
	<49E6E155.6090000@zankel.net>
	<20090416012447.fd6e6dee.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Apr_2009_18_35_43_+1000_0NTCLpSUdZW7AyQ7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Apr_2009_18_35_43_+1000_0NTCLpSUdZW7AyQ7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Thu, 16 Apr 2009 01:24:47 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 16 Apr 2009 00:42:13 -0700 Chris Zankel <chris@zankel.net> wrote:
>=20
> > Hi Andrew,
> >=20
> > I will look over those patches and commit them to xtensa-2.6.
> >=20
>=20
> OK.  I have a random pile if i-dont-know-what xtensa stuff here.

Interestingly, there is an xtensa tree in linux-next that tracks the
master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/czankel/xtensa-next.git.
It hasn't been updated since January ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Apr_2009_18_35_43_+1000_0NTCLpSUdZW7AyQ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknm7d8ACgkQjjKRsyhoI8yJqACeN2bGb7Z7TWys8QXCmOnl2/Zc
ncEAoJbWzyUXHsSP5uQX1ilIKX3/1YSj
=N/+Q
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Apr_2009_18_35_43_+1000_0NTCLpSUdZW7AyQ7--
