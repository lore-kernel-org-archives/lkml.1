Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZG0QGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZG0QGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZG0QGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:06:50 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZG0QGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:06:50 -0400
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1248710618.1216.452.camel@rc-desk>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u4cDgwnuxr0nibRXaxlu"
Date: Mon, 27 Jul 2009 18:06:15 +0200
Message-Id: <1248710775.9958.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u4cDgwnuxr0nibRXaxlu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 09:03 -0700, reinette chatre wrote:

> > I definitely have rfkill on. I tried to even toggle rfkill, no success.=
 The HW
> > is Lenovo T61 (thus acer/hp rfkill patches do not work for me).
>=20
> Maybe Johannes knows if there is something that you need for thinkpad.

I'm not aware of any thinkpad-acpi rfkill problems, can you get the
rfkill tool and dump the status/list?

http://wireless.kernel.org/en/users/Documentation/rfkill

johannes

--=-u4cDgwnuxr0nibRXaxlu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbdBzAAoJEODzc/N7+QmayuwP/0T495a1g8jPYoCARr9HWoQa
oMFwbbEKcWgfbcTVIREuH2Kh21Lskly0+/k+5UE65A9ft089CApEohgsecDlfxRF
DQMnrYLMPh5aHxO3r90OeB+0KEqudtYS81oskPuvnWUk9eDB2V5KRnBw0c9Bhxdp
aYoB6BqWoC782++U4FRRohdpzm1op/cO6FlstuJpvAFbS82F8dOThYHBCIzWg7Lo
2NCBlXHycZetH7yzpSuKYdj6Za/pHnZqPxK2ufp9ySF2TDo6HKtgOKNRF1pCAFuv
Lat+egTtVCrTZp+tAbvCFOuTmjOF/ArU8cyFuMYDeRtc1aTatXWJxJ91tXolPEfL
TUrXIj9Ii5G0cRYE9ShTR8qfNjeY3kDDe1J4YsQQSjyuo0wXYL42V1Nv5P0q7lXo
18Uth3ZoQmrDJrhPpdABKdDqPd+8jF9gEdrhoyfdApns0A7xpjlivxts8tqFENPI
KOjN0Ju6rgqeIn+0smjkPv1qNeQZY5RxIhZY8An8Qk5EveBiydKb+Hp2cz2nG3l1
idHDlFh4bEKJ/akFAuXaIvh/fPtqkM7FauP3EhwXymEywwE+D32SSAAxiyTeFtCY
L6ujvwKAi5ksG4/9TNv7yIoDDyp0TxJ412kMe7FfdZ3NHi1Yjupj6qg8XOWlgCF+
IWJEPKRQARTyx3tz6wUc
=DwTc
-----END PGP SIGNATURE-----

--=-u4cDgwnuxr0nibRXaxlu--

