Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbZJNVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbZJNVN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbZJNVN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:13:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33182 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587AbZJNVN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:13:27 -0400
Date: Thu, 15 Oct 2009 08:12:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 14
Message-Id: <20091015081245.832eed66.sfr@canb.auug.org.au>
In-Reply-To: <20091014085515.f40067c1.randy.dunlap@oracle.com>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
	<20091014085515.f40067c1.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Oct_2009_08_12_45_+1100_Mpvbiy1S5Et2J9nj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Oct_2009_08_12_45_+1100_Mpvbiy1S5Et2J9nj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 14 Oct 2009 08:55:15 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> Where are today's .bz2 file and the .sign files?

I only upload the .gz and some global script creates the other files
automatically.  That seems to have failed sometime yesterday but someone
has fixed it, now.

> and when did pub/kernel/people/sfr/linux-next/ disappear?

/pub/linux/kernel/people/sfr/linux-next is still there (it is a symlink
to /pub/linux/kernel/v2.6/next).

> The kernel.org/kdist/finger_banner file now reports:
> The latest linux-next version of the Linux kernel is:         next-200910=
13

That would probably be the same problem as above.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Oct_2009_08_12_45_+1100_Mpvbiy1S5Et2J9nj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrWPs4ACgkQjjKRsyhoI8xsZgCgrqHgbd1VWG3OAEYuhJcrdY+/
dWIAoLiha/b5g2DiZkZUJyTjAoAudQQ3
=akhN
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Oct_2009_08_12_45_+1100_Mpvbiy1S5Et2J9nj--
