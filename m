Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYHFFoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYHFFoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYHFFop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:44:45 -0400
Received: from molly.corsac.net ([81.57.48.219]:58973 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYHFFoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:44:44 -0400
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
From: Yves-Alexis Perez <corsac@debian.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080806023247.GA4665@khazad-dum.debian.net>
References: <20080805183725.GA4468@srcf.ucam.org>
	 <1217965470.5449.4.camel@hidalgo> <1217972874.4540.3.camel@hidalgo>
	 <20080806001301.GA10630@srcf.ucam.org>
	 <20080806023247.GA4665@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RpCPsGp50FHDMkYD7GWa"
Date: Wed, 06 Aug 2008 07:44:45 +0200
Message-Id: <1218001485.4540.15.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RpCPsGp50FHDMkYD7GWa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On mar, 2008-08-05 at 23:32 -0300, Henrique de Moraes Holschuh wrote:
> Well, for what is it worth, thinkpad-acpi has a knob (brightness_mode)
> which
> can be used.  Set it to CMOS mode (see docs).  From what I recall, it
> should
> do what your patch does.

It's worth noting that I get the 750 ms delay even when I reload
thinkpad-acpi with brightness_mode=3D2 it got it (but maybe I should
reboot before to be sure no one messed with EC).
What's strange too is that brightness keys work fine when thinkpad-acpi
isn't loaded, so everything seems done in video.ko.

Cheers,
--=20
Yves-Alexis

--=-RpCPsGp50FHDMkYD7GWa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiZOkcACgkQTUTAIMXAW67+PwCgg6CHAk9Y23tz8UpOUmOryvFA
WBYAoI4qsRlJhGu/ZW/Y+VUVz2gLiv8L
=jNYA
-----END PGP SIGNATURE-----

--=-RpCPsGp50FHDMkYD7GWa--
