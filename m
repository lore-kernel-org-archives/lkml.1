Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbZATXtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbZATXtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZATXsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:48:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39357 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbZATXsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:48:51 -0500
Date: Wed, 21 Jan 2009 10:48:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Samuel Ortiz <sameo@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [GIT] MFD pull request (build failure fix)
Message-Id: <20090121104836.fd1df471.sfr@canb.auug.org.au>
In-Reply-To: <20090115112232.GA2794@sortiz.org>
References: <20090115112232.GA2794@sortiz.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__21_Jan_2009_10_48_36_+1100_9PfUYWH9_QAfFm.o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Jan_2009_10_48_36_+1100_9PfUYWH9_QAfFm.o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 15 Jan 2009 12:22:32 +0100 Samuel Ortiz <sameo@openedhand.com> wrot=
e:
>
> Could you please pull from my MFD tree ? I have a build failure fix for
> pcf50633 on several architectures.
>=20
> The following changes since commit 5393f780277165f282a37ed82dd878159ec9da=
d5:
>   Linus Torvalds (1):
>         Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc
>=20
> are available in the git repository at:
>=20
>   git://git.o-hand.com/linux-mfd for-linus
>=20
> Balaji Rao (1):
>       mfd: Remove non exported references from pcf50633

I have been applying this to linux-next (after starting from your tree)
for over a week.  It is necessary to allow x86_64 allmodconfig to build
(at least).  It would be good if you could find a moment to merge this
into your tree.

Thanks

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Jan_2009_10_48_36_+1100_9PfUYWH9_QAfFm.o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl2YtQACgkQjjKRsyhoI8wKGgCfdjoDdd1asYavN+hpPwxxJKM9
1F0An1TKWwLBXK+k6mkEBgoWUKDUObYx
=n3PU
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Jan_2009_10_48_36_+1100_9PfUYWH9_QAfFm.o--
