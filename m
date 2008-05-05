Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbYEEV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbYEEV1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYEEV1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:27:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbYEEV1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:27:11 -0400
Subject: Re: w35und: driver now down to 16Kloc, and actually works a bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080505210138.GE7273@elf.ucw.cz> (sfid-20080505_230048_056688_3BEEDCE8)
References: <20080505210138.GE7273@elf.ucw.cz>
	 (sfid-20080505_230048_056688_3BEEDCE8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4kYmiSwLTXo6PMbJVBcM"
Date: Mon, 05 May 2008 23:02:49 +0200
Message-Id: <1210021369.4181.43.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4kYmiSwLTXo6PMbJVBcM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 23:01 +0200, Pavel Machek wrote:
> Hi!
>=20
> Ok, code is still extremely ugly, but at least it uses softmac (and

why not mac80211? softmac has been deleted

johannes

--=-4kYmiSwLTXo6PMbJVBcM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB91+KVg1VMiehFYAQJPVBAAomjk7a3Gwdq8DogG8vDhih2rpCqsG5/B
TTA3PyTPsoeCYGLjK+5lQ0s0Fq9GzT+rLEc8K4z8EHlq75QUBNj7wPKrQD59Md77
mV5MorOQW8J/4KFpYKn7BE4GK0i57uwELMTvHTUvkCjhvq/tGNb5Zccu/jENp9My
zPgqCQDgSFyNLGX5NfKiWZppB20bCWMaPVmKpguRhu6JffgqdkVgD7EN2+YspZM+
SH1xVm3WORoPxcZm/o8JM4SLX1yHmEv6ccJ6J6rQVPjYRGWHwcigrOTcoh9DCR4e
r/gy5iaCbB65sMhq+TyOV1t8efGpeXZq41ONp8xI0CDei22DF2buI1cUVVIV0Ji1
wtSVOfmFZ0k1Z1prUNmpZUBXD5vgaE98nCv3OqtqrdDksBoBP34RjTHp8IESShs/
s0a2GhYJ6hbw5GWy3YoxGlEzSIAoJrNPr+HGQQgxk5G1yovWkzceS1ZmbifS1LgI
w68HyKs5AEBG/AAy7iuMwv733rVNUI4SNlb8AXlVuL1lW4SKYR8l8Ob5aJnDYrHU
c3ci4EIsZLDdchc1vHlVgvY5d12sYerW9UeXv9OPH3Ac7lES1GnrqAYu6zL5cB52
+RGdGrTex6UYhMwDISBy4H+kXHKXDTP8gWZuUVxUk5fPlQZm1vp0dxA9GEZMsgCA
s5ps5Vm6GOo=
=B0c2
-----END PGP SIGNATURE-----

--=-4kYmiSwLTXo6PMbJVBcM--

