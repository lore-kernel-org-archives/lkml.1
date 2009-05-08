Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZEHJCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZEHJCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZEHJCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:02:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZEHJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:02:11 -0400
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Daly <jason2@primarykey.ca>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Karl Hiramoto <karl@hiramoto.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <6818156.7441241761835737.JavaMail.james@prod3.pk.lan>
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com>
	 <4A02B1CA.3060708@hiramoto.org>
	 <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com>
	 <6818156.7441241761835737.JavaMail.james@prod3.pk.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-h970Vm30s6lM3LS133hW"
Date: Fri, 08 May 2009 11:02:04 +0200
Message-Id: <1241773324.1567.33.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h970Vm30s6lM3LS133hW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-09 at 01:50 -0400, Jason Daly wrote:
> Thanks for the kernel info.
>=20
> How do you configure hostapd to work in N mode with ath9k?  Currently=20
> the hw_mode parameter found in hostapd.conf does not accept anything=20
> greater than g.

N isn't "greater than" G. N is more features than G. Just set the N
options in the config file. You may need a git hostapd, I don't know for
sure.

Also, please set your clock and timezone correctly _before_ you say
"thank you"!. You have posted on
	Sat, 09 May 2009 01:50:12 -0400 (07:50 CEST)

which is clearly impossible.

johannes

--=-h970Vm30s6lM3LS133hW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKA/UCAAoJEODzc/N7+QmahqgQAJnKJRl39qz78L3dQyNfus2J
Ukho9/cYBulUcLxLbMxFb8M7FtkmHcZGZPf9w5x/l+UBU4pZuP2+1poMeRT1fq5N
Rh/x1sU4es7+4rPigO7PNH1zgpgufO5lmLhcmPzNZWLyRc4j6XxBAk3Gxa2YeEmt
TXfkNit/cLjeSF4s/tSzVA1OikQRN+K2oUAEt4S2sd5Ln8FGMEOXm831/390KK7e
juC7JzSvS9XnoVWgKn5FnL4wbDBwm9LAowO/lTdHIw6xj+u7lddfBy5oOhoP+95x
sEzm37A/FcHuD2J3qnOAGGPCR2oFJG+KlGgpu//FjtuVgdPBCgtYjCHcjzvQjst0
Dsb0coAjuFbi7Qq6NpgRJnWJLNsqZUZPSMGQDdumaySb3rzby6MRnZ+rJmz8R5QB
ARB+Lr29hN7t00sG7jNriAs75gwgKl3dTWzI8Sy0Gcme5GuSYL022cwV0mXkLTVy
ap1HKddGpO6DTbv78Z4NNieyG+eW5dcO3Wey216kFjIf+ei9H1CyW0RvXrDVosBY
0uxsR9SR/mHYC0IvXdtqBCox+9rcpCX5sgpTGHXW1jZcCNPGFNzOagjOlD93X8LT
f93qbmuwyNZs2iDBtAHnUhZ91OTlwOKx5WbnnmsZp41CiPjiMX6LDvz1R59x2eUg
Uw1v8zof+xl10ul3Dw+L
=a0Cg
-----END PGP SIGNATURE-----

--=-h970Vm30s6lM3LS133hW--

