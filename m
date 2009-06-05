Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZFEWGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZFEWGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZFEWGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:06:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:50926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZFEWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:06:36 -0400
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f3vsak4YmTXKurATDDCA"
Date: Sat, 06 Jun 2009 00:06:31 +0200
Message-Id: <1244239591.7876.30.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f3vsak4YmTXKurATDDCA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 12:04 -0700, Luis R. Rodriguez wrote:
> I'm pleased to announce we have released the source code to our
> Atheros 802.11n USB Otus/ar9170 device under the GPL. You can grab the
> source, compile and use it with the upstream ar9170 device driver.
> Patches are welcomed. The git tree available for this is at:
>=20
> http://git.sipsolutions.net/ar9170-fw.git
>=20
> For more information please visit the home page for this project is on
> our Linux wireless wiki:
>=20
> http://wireless.kernel.org/en/users/Drivers/ar9170.fw
>=20
> The ar9170 device driver home page is at:
>=20
> http://wireless.kernel.org/en/users/Drivers/ar9170
>=20
> I'd like to thank Johannes Berg and Christian Lamparter for their
> incredible contributions to the project both firmware and ar9170
> driver so far without which this would not have been possible.

So, plan: I would like to add a command that tells us
   - it's open source firmware
   - what additional capabilities the firmware has
This has to be a command like the debug commands that we can send from
the firmware unilaterally. Easy to do.

What I would then like to add is at least proper tx status reporting. I
would also like to get rid of the key limitation, if possible.

johannes

--=-f3vsak4YmTXKurATDDCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKZbjAAoJEODzc/N7+QmagesP+waJHvVERwX6PtDAQjGNTY/C
eRcPI5pj8Sv4Sk9GdeWPHufl4+m5edgA+0k6DURA6uhwSkDpATy8USSzjNlcB584
HbTTxixEnjcWfGIw1iqdeUpJXBO0TT4EXZkHrqlLeGE8c/RHc+nlhopOcxMgCsOC
2gWxWZLsjbTkgljICKg42an9JcNWqmrQprGwy2n4EhGIKJKS9TiqtVUI2Vj8XQtm
pC+PBAI3EEBsd1xHYyVYfuArqyRs5bYYFO7qrttik5vHsMzKdGOcP1DGsnRzRZvz
70+gnIms2N8rbElXWT+U5afGv1zFlq0RWPI66fb7QGR3jz+AoyKRAw+MRevGkXcf
BX2YjczFk6TMpH9GoS8k5ssfxvR5aIp7SudEpwKL+tHlD6FkG0hryMDNGjaB8cyb
ecIIsSmQC+nuST+98qAiydpdIFODOQCsQErl4wlfExaVAynGBRkxuS/Tdn7XnDlZ
9/MdeUoUtqFEgXc79R66GGhw0Dt/N7F4z03ahghhvcYGN2CmiBsnJLLzERGOHQUl
k2ohhITyOcMoljDc/B5a/pM/KQsqVINPAajcm3vuF1Z9ahxYGeImGmnWiauIrShE
dvhfAgw6kp4DItMfnkPNbmTPXx2Dz73UHVrTqEtuYv/8yUr6UKSoPLIm/sVRG0u8
WQF3D4jHuFqDFolPujdS
=gT6u
-----END PGP SIGNATURE-----

--=-f3vsak4YmTXKurATDDCA--

