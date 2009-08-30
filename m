Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZH3RSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZH3RSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZH3RSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:18:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42441 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZH3RSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:18:33 -0400
X-Sasl-enc: b+2gMtzUgv4B5ROeP8S1k9lrYmZyAaQ10GMnY7+Iw3mW 1251652712
Message-ID: <4A9AB45B.6060500@imap.cc>
Date: Sun, 30 Aug 2009 19:18:19 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: stable-review@kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: Would it help to encourage users to read/test stable-review patches
References: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com>
In-Reply-To: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig88595DA8D52B081C970977DE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig88595DA8D52B081C970977DE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Luis R. Rodriguez schrieb:
> We get development review eyes on stable patches during submission
> into a subsystem, and perhaps 1-2 user tests then. Typically patches
> are pretty easy to review for stable submission but I'm wondering
> about cases where things are not so clear [...]
> Do we want more user exposure to stable-review mailing list or is just
> a few developer eyes enough?

Having been bitten quite recently by a -stable mismerge, I am of two
minds about this. On one hand, it would have been nice to catch that
problem during stable review instead of when it hit an actual
distribution. (Ubuntu, as it happened.) On the other hand, I'm not
sure user exposure would have helped all that much in this case.

Generally speaking, the way I understand stable rules, those cases
where things are not so clear shouldn't make it into the review in
the first place. The problem is with the cases where things appear
to be quite clear but aren't. Those are the ones the review cycle
must catch.

Jm2c
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig88595DA8D52B081C970977DE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKmrRlQ3+did9BuFsRArw9AJ4wSgAN4x5GDxU/0MDC9aHyTC1EOgCbBj6z
W2m4MeICum3xkW3yhP2xix8=
=aYL5
-----END PGP SIGNATURE-----

--------------enig88595DA8D52B081C970977DE--
