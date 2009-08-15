Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZHOBRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZHOBRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 21:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZHOBRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 21:17:37 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:58733 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZHOBRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 21:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=mJQGzu1yH7gfy7p2hFl5cLXpzq4hxFOo3gsV76NrDjJcZweliuMIWCUtaDsy6GovAv
         HGL1vFtnVYQoR5JQ+C9sZwkKs/ycPT1kMg1IVx1ILWFInNfQl4pOlrLMyxB6/CQg/IpV
         tzuYXHk99NjGH6NhucozQU+NKDKl0OtVgLmL0=
Subject: Re: [RFC] Freescale MC13783 PMIC support
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090811122842.GG24947@sirena.org.uk>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de>
	 <20090811140500.2678b289.ospite@studenti.unina.it>
	 <20090811122842.GG24947@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MaOrQ9Xo/pVz/C0xFbTy"
Date: Fri, 14 Aug 2009 22:17:41 -0300
Message-Id: <1250299062.18028.264.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MaOrQ9Xo/pVz/C0xFbTy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Ter, 2009-08-11 =C3=A0s 13:28 +0100, Mark Brown escreveu:
> > PMICs in one system (quite unlikely scenario?), read actual pressure
>=20
> It's vanishingly unlikely that you'd see two Atlases in one system - you
> might see two PMICs but not two primary PMICs with stuff like battery
> chargers on them.

There are some GSM Phones from Motorola with PCAP2 + MC13883 (based on
MC13783, but with USB and regulator blocks only). On these phones the
battery charging, and USB OTG capabilities of PCAP2 are unused.

All "gen2" devices on http://wiki.openezx.org/Project_devices use PCAP2
+ MC13883. "MotoMAGX" devices use MC13783 only. And "gen1" PCAP2 only.

--=20
Daniel Ribeiro

--=-MaOrQ9Xo/pVz/C0xFbTy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqGDLUACgkQw3OYl0G0liQqEQCghLoyZwLCTWoaVfgiGIeVnVWD
mbcAnjzL6ac8g9Pw/HHC26q0tirEYan0
=Ro4h
-----END PGP SIGNATURE-----

--=-MaOrQ9Xo/pVz/C0xFbTy--

