Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZDVPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZDVPBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZDVPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:01:46 -0400
Received: from intcomgrp.com ([216.54.13.120]:44588 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZDVPBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:01:45 -0400
Message-ID: <49EF30F5.7030108@beta.intcomgrp.com>
Date: Wed, 22 Apr 2009 11:00:05 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it>	<ct38K-3Fq-9@gated-at.bofh.it>	<ctmXD-1yA-3@gated-at.bofh.it>	<ctnK4-2zP-11@gated-at.bofh.it>	<ctoG9-458-7@gated-at.bofh.it>	<ctoG9-458-5@gated-at.bofh.it>	<ctoPK-4y5-5@gated-at.bofh.it>	<ctoZv-4KN-23@gated-at.bofh.it>	<ctFxn-5OC-11@gated-at.bofh.it>	<ctG0r-6HL-31@gated-at.bofh.it>	<49EF2A3C.2050107@support.intcomgrp.com> <20090422154920.0dda2380@lxorguk.ukuu.org.uk>
In-Reply-To: <20090422154920.0dda2380@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EA888F2C77F5D9D815BEDCC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EA888F2C77F5D9D815BEDCC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alan Cox wrote:
>>> In power management line normally refers to the core, unregulated pow=
er
>>> bus for the system and a line supply would normally be something like=
 a
>>> wall wart that supplies this directly when it's connected.
>> Can I suggest:
>> "supply-switch" or "regulator-switch" may make more sense for the mome=
nt.
>=20
> Can I suggest they don't. The naming should reflect the naming actually=

> used in the field by people working on the technology otherwise arbitar=
y
> renaming just creates confusion
>=20
> The supply switch is the big switch on the back
>=20
> Alan
>=20
Ok, "supply-switch" may have been a bad idea, I wasn't thinking yet.
The coffee hasn't kicked in yet and I'm feeling a bit down.

James


--------------enig2EA888F2C77F5D9D815BEDCC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknvMPkACgkQkNLDmnu1kSl3yACeMKZQOxUJUKwSlRL4tuIaOStq
QNkAnRwnQkNAeJZusurGaU6UCH20W0rg
=1yjB
-----END PGP SIGNATURE-----

--------------enig2EA888F2C77F5D9D815BEDCC--
