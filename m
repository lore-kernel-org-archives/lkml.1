Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYI2I2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYI2I2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYI2I1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:27:53 -0400
Received: from mail.anarazel.de ([217.115.131.40]:36662 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYI2I1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:27:52 -0400
From: Andres Freund <andres@anarazel.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Date: Mon, 29 Sep 2008 10:27:49 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-rc7; KDE/4.1.2; x86_64; ; )
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200809251511.20132.andres@anarazel.de> <1222441955.3798.13.camel@johannes.berg> <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
In-Reply-To: <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1577835.l5VFPfxJ2h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809291027.50453.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1577835.l5VFPfxJ2h
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Saturday 27 September 2008, Tomas Winkler wrote in "Re: bad DMAR=20
interaction with iwlagn and SATA":
> Meanwhile it all reported bugs in this case points to 64 bit
> installations, I'll give it more testing
Would it help to test on 32bit? I have some dissk with 32bit system install=
ed=20
lying around somewhere...

Any other patches to try?

Andres

--nextPart1577835.l5VFPfxJ2h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjgkYYACgkQporPraT14ih2MwCfSIgBIgsrNfWIhpQh/bzMNsX9
u68An1P8oc0Ar347iHUA49Vmg0IhSLGS
=hT7l
-----END PGP SIGNATURE-----

--nextPart1577835.l5VFPfxJ2h--
