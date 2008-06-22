Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYFVTXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYFVTXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYFVTXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:23:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:57898 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYFVTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=AjgUsALle2CcwmoeldJNy4lTiqNKZWtL1WuDHVc5THi/+JogHl62dg/fM39Sb+sxaX
         3SQ2e6d6jOV3bH1S0KvUHDuOgc44rYN/TW4Gx/wPcCMco/QpBC/rmF54ZBnlMpca0Ev7
         S7lUt0cNM/XRiPEnq0XshN2XUv8SwmsPSAeIQ=
Subject: Re: [Bug #10830] two different oopses with 2.6.26-rc4
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4mRZUF-hVeG.A.GeF.jupXIB@albercik>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	 <4mRZUF-hVeG.A.GeF.jupXIB@albercik>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sQRaTdgdqISbZ3Dck+6V"
Date: Sun, 22 Jun 2008 21:23:11 +0200
Message-Id: <1214162591.6803.1.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sQRaTdgdqISbZ3Dck+6V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El dom, 22-06-2008 a las 19:54 +0200, Rafael J. Wysocki escribi=C3=B3:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

No it should not

The oopses disappeared on 2.6.25-rc5 thanks for the time to
all people involved

>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D10830
> Subject		: two different oopses with 2.6.26-rc4
> Submitter	: Alejandro Riveira Fern=C3=A1ndez <alejandro.riveira@gmail.com=
>
> Date		: 2008-05-28 9:50 (26 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D121196833026310&w=3D4
> Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 		  Andrew Morton <akpm@linux-foundation.org>
> 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> Patch		: http://lkml.org/lkml/2008/5/20/683
>=20
>=20

--=-sQRaTdgdqISbZ3Dck+6V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkhepp8ACgkQ3GEkiSnUSOF8VQCeJtbK4R0jAdh1KkPpwTsYeYYg
fQQAoIhRztDL/1/JsFHRP3hL6PI0aAlF
=NCaL
-----END PGP SIGNATURE-----

--=-sQRaTdgdqISbZ3Dck+6V--

