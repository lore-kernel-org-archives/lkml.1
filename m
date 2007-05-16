Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbXEPVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbXEPVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759984AbXEPVWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:22:11 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:36134 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbXEPVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:22:11 -0400
Date: Wed, 16 May 2007 11:27:36 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: Daniel Drake <dsd@gentoo.org>
Cc: Duane Griffin <duaneg@dghda.com>, Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070516212736.GO15763@ifa.hawaii.edu>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <464B63D8.2060501@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tDYGg60iReQ7u8wj"
Content-Disposition: inline
In-Reply-To: <464B63D8.2060501@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tDYGg60iReQ7u8wj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2007 at 04:04:40PM -0400, Daniel Drake wrote:
> Duane Griffin wrote:
> >On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
> >>Maybe you want to give a hint in the p states driver help text?
> >
> >I think a hint is the right thing to do, but in the PowerNow! driver
> >rather than the p states one. How about adding something like this to
> >the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:
>=20
> Please hold off this patch until we've gained a more complete=20
> understanding of the issues and workarounds (which will probably lead to=
=20
> us writing a better patch anyway)

I agree - the issue is more complicated that I had thought.  I received
an off list message saying that this dependency isn't required on a
single-socket Athlon X2 system.  So it sounds like isn't an SMP setup
issue as much as it is a multi-socket or perhaps just an issue with my
vendor (Tyan).

-J

--

--tDYGg60iReQ7u8wj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGS3dIWa2BU+b7tU0RAn48AJ4/dhSKZy4t0yVtgTyhRSYB+EJPfwCcCq1a
j7PP7ciLH7ly+oPLf69p6Mc=
=K8bm
-----END PGP SIGNATURE-----

--tDYGg60iReQ7u8wj--
