Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZIZLon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZIZLon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZIZLom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:44:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47652 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbZIZLoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:44:39 -0400
X-Sasl-enc: vOUyxvk8eyzC7S49v2GWw1Gs9XSHy/bERaUzFBF8BVjZ 1253965483
Message-ID: <4ABDFE9F.2030404@imap.cc>
Date: Sat, 26 Sep 2009 13:44:31 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>
CC: davem@davemloft.net, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ISDN patches for 2.6.32 (v2)
References: <20090919-patch-capi-0.tilman@imap.cc>
In-Reply-To: <20090919-patch-capi-0.tilman@imap.cc>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2E7DCB873CC45A615004EF4A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2E7DCB873CC45A615004EF4A
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello Karsten,

is there any chance of getting these and the Gigaset patches forwarded
for inclusion in 2.6.32 before the merge window closes?
If not all of them, perhaps at least those which you had already acked
before David Miller asked that they should formally go through you
(#2-4 of the ISDN series), and those which are just fixes to the
existing i4l version of the driver (#1-10 of the Gigaset series)?
I would really appreciate not having to maintain all of them out of
tree for another release cycle.

Thanks a lot,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2E7DCB873CC45A615004EF4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKvf6nQ3+did9BuFsRAmMrAKCCjw+jlZ2aNyXfj/qlbso99ImTnQCdHm28
ePGJ6d5gQa7pH2au0f0zcjU=
=EpF9
-----END PGP SIGNATURE-----

--------------enig2E7DCB873CC45A615004EF4A--
