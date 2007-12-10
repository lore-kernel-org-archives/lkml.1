Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXLJIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXLJIld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLJIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:41:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:35763 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750941AbXLJIlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:41:25 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+CMjxPudSCSqX+UkDVu3b3BU00cItNUdT5dlHQbQ
	PgxXlQiDErZ49x
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Date: Mon, 10 Dec 2007 09:41:17 +0100
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Drake <dsd@gentoo.org>,
       linux-kernel@vger.kernel.org
References: <200712031419.41596.toralf.foerster@gmx.de> <200712032254.23656.rjw@sisk.pl> <20071209174108.GH4381@ucw.cz>
In-Reply-To: <20071209174108.GH4381@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21774807.ifqkJKEJxY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712100941.21056.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21774807.ifqkJKEJxY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag, 9. Dezember 2007 schrieb Pavel Machek:

> I smell refrigerator problem; can you suspend if you SIGSTOP your uml,
> first?
No, I cannot suspend my host system if I send SIGSTOP  to the UML process f=
irst.



=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart21774807.ifqkJKEJxY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHXPuuhyrlCH22naMRAu4gAJwJVkYZiGbPIBy0zEhOArOJXW+XpwCgkOL1
HSp7aZI463Wj/inV9hOBHW4=
=IAsX
-----END PGP SIGNATURE-----

--nextPart21774807.ifqkJKEJxY--
