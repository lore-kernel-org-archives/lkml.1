Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYAHTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYAHTl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYAHTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:41:18 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:54493 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbYAHTlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:41:17 -0500
Date: Tue, 8 Jan 2008 20:41:14 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "raki john" <raki4652@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replacing drivers/mmc directory in kerenl 2.6.22.1 with
 drivers/mmc in kernel 2.6.23.1
Message-ID: <20080108204114.7d3e1d56@poseidon.drzeus.cx>
In-Reply-To: <d2a348dd0801062002g762c6946u157790646725cd80@mail.gmail.com>
References: <d2a348dd0801062002g762c6946u157790646725cd80@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-1340-1199821275-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-1340-1199821275-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 6 Jan 2008 20:02:46 -0800
"raki john" <raki4652@gmail.com> wrote:

>=20
> Can I replace drivers/mmc directory in 2.6.22.1 with drivers/mmc
> directory in 2.6.23.1.   Does this cause any issues. Is there any code
> in drivers/mmc in 2.6.23.1 which depends on other features in kernel
> 2.6.23.1.
>=20

I'm afraid I've not kept track of such things. Try it and see if it compile=
s.

Rgds
Pierre

--=_hera.drzeus.cx-1340-1199821275-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkeD0doACgkQ7b8eESbyJLjgJQCeICvNVAknRlf3TXogWm4F8IgQ
HoQAnj1QLsio4rpDrQdlzlIGlMfD7Eim
=aKjW
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-1340-1199821275-0001-2--
