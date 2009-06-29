Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZF2DoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZF2DoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZF2DoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:44:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58860 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbZF2Dn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=bkb03GK6kWK/93Xg2AIT1c2n3/GxtIZfAb9e5Lq2ISlmFI6CCJi024/g8dNPIX9ATq
         wdrjAf4ROfCukLjDsHNwrQGfF7bGbXmS4npeh38vVICvq8sy4ukIURF3zL63Qr4g3SVZ
         e19aLCdOq0Lk5ftvQ4OB1Tq1s/nshutlO8UkI=
Date: Mon, 29 Jun 2009 06:44:17 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [Bug #13655] [Oops] 2.6.31-rc1: tun
Message-ID: <20090629064417.2fd6ac63@mosly.slynet.org>
In-Reply-To: <6JJ2m5kyucK.A.b1C.AJASKB@chimera>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	<6JJ2m5kyucK.A.b1C.AJASKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yzEQ.ejKCniBL9sUU6e3YAD";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yzEQ.ejKCniBL9sUU6e3YAD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jun 2009 02:11:48 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13655
> Subject		: [Oops] 2.6.31-rc1: tun
> Submitter	: Sergei Trofimovich <slyich@gmail.com>
> Date		: 2009-06-25 23:53 (4 days old)
> References	: http://lkml.org/lkml/2009/6/25/435
> Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>
> Patch		: http://patchwork.kernel.org/patch/32672/
>=20
>=20
This bug is a duplicate of http://bugzilla.kernel.org/show_bug.cgi?id=3D136=
27

--=20

  Sergei

--Sig_/yzEQ.ejKCniBL9sUU6e3YAD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpIOJcACgkQcaHudmEf86qExgCfUJY/6P68IDiU/pnWHWRhqh+t
I7cAoIRtTyG8UojqgmoGYEycTuOFKp9V
=nPcT
-----END PGP SIGNATURE-----

--Sig_/yzEQ.ejKCniBL9sUU6e3YAD--
