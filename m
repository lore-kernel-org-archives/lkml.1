Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbZGXOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbZGXOtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZGXOtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:49:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZGXOta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:49:30 -0400
Subject: Re: Generic events for wake up from S1-S4
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ykzhao <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20090724133903.GA18827@khazad-dum.debian.net>
References: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
	 <20090723195114.GR28158@elf.ucw.cz>
	 <20090723201050.GD19369@khazad-dum.debian.net>
	 <200907232328.03566.rjw@sisk.pl>
	 <1248396826.3556.26.camel@localhost.localdomain>
	 <20090724133903.GA18827@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k3uMWwkqwgmLBnwDG77h"
Date: Fri, 24 Jul 2009 16:49:16 +0200
Message-Id: <1248446956.32151.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k3uMWwkqwgmLBnwDG77h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 10:39 -0300, Henrique de Moraes Holschuh wrote:

> ACPI notifications are hard to extend, I think.  Please correct me if I a=
m
> wrong.

ACPI is the wrong place anyway, since it's fundamentally platform
dependent. Unlike the rest of suspend and wake functionality.

johannes

--=-k3uMWwkqwgmLBnwDG77h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKacnoAAoJEODzc/N7+QmaSScP/R7Y3kpqY/fbBkNKBopqkkpE
eEmGWiYd31VOMMVlcyjQYCogkTc1m7u5PDou7s3pFyqS+Aq8ypFbCsYKuoZRzFFg
69lUr7hLyyHBF7Bb/CwoXAVsoSqdwUvCG0eHLK86KjYnzYurhd//oJq/yXzZbQfz
XmzoUZJk6cFLR4cZ8ZYsPIHfdJi7k3wFulcl1CGRqBvdJt0JdR1wz8c7M5ieMDJN
TER0JsXzkuuPd6i4eqNhOi47y8BeC5JrTXcw5RitxnRFwdd5mAvRpf43eTkdWnZq
y2AiJ0wfSYeTNXVZM5Fc9wOpzWYKcK3BD1YaRtFad5lYS5CK8njCX/yI3yl4PI2g
+H7x5Ur/YikUIHtTg70qNGj/HQ7XoeRqOGIVPP2uo5EJlBWgVrwlGvLLdrzB5eO1
ejhW4mMQo01T0EFz/E0L1l/ptSRE7GOcXuub258Md8SCX8qxHilFVSebRGP/GreC
voc4gKMOlVE+yXvyBEAcJgz6O5YU/f1HHrRRtLU2JzI9KVO/mVc7fBGsXNU/TIuK
WK9JW9BdrzVjshk6HjP9SheOjGCPlEZVeN9dXUbAHiJW3sErOo8m6OKo66UDAiDd
MZvfqvIRz/qfNGxMXSR9l4mfskzg/fkDxkuR1uf0rdjnwi4bgzV82J+9ZErabd3J
CIYyGQg0Nta9kejlVpoc
=92Uq
-----END PGP SIGNATURE-----

--=-k3uMWwkqwgmLBnwDG77h--

