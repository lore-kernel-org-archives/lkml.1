Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZBTRji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZBTRji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZBTRj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:39:28 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:51790 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZBTRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:39:27 -0500
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
From: Scott James Remnant <scott@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
In-Reply-To: <20090220173637.GA1985@srcf.ucam.org>
References: <20090218182822.GA19902@srcf.ucam.org>
	 <20090218183137.GD26802@elte.hu> <20090218183641.GA20203@srcf.ucam.org>
	 <1235150992.6467.66.camel@quest>  <20090220173637.GA1985@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TbZY73IiJO43jGx+K8Vw"
Date: Fri, 20 Feb 2009 17:39:35 +0000
Message-Id: <1235151575.6467.68.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TbZY73IiJO43jGx+K8Vw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-20 at 17:36 +0000, Matthew Garrett wrote:

> On Fri, Feb 20, 2009 at 05:29:52PM +0000, Scott James Remnant wrote:
>=20
> > In fact, we've noticed severe regressions with p4-clockmod over simply
> > having no scaling driver at all - and are not going to built it into ou=
r
> > kernels.
>=20
> It makes sense to have p4-clockmod from a thermal management=20
> perspective. We should probably bump its transition latency to more than=20
> 10ms to prevent ondemand binding to it.
>=20
If that's possible; that'd be good.

The trouble with it is that it never seems to bring the CPU anywhere
near maximum performance.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-TbZY73IiJO43jGx+K8Vw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkme6tcACgkQSnQiFMl4yK5RmgCfZGNhQLhwJYJSBeOPRl7q6ioK
UQ0An3kJdrdX9bRWHKFc5CMDovVHajKR
=CxaL
-----END PGP SIGNATURE-----

--=-TbZY73IiJO43jGx+K8Vw--

