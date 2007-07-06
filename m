Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbXGFXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbXGFXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXGFXBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:01:12 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40425 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXGFXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:01:11 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Date: Sat, 7 Jul 2007 09:01:11 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
References: <200706221607.33274.nigel@nigel.suspend2.net> <200707052104.27693.nigel@nigel.suspend2.net> <20070706150451.GA11400@suse.de>
In-Reply-To: <20070706150451.GA11400@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6042013.TqJtlfO50o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707070901.11605.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6042013.TqJtlfO50o
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 07 July 2007 01:04:51 Stefan Seyfried wrote:
> On Thu, Jul 05, 2007 at 09:04:27PM +1000, Nigel Cunningham wrote:
> > >=20
> > > If confusion persist after 4 seconds hard power down... then you h ve
> > > hw/BIOS problem. Complain to whoever is manufacturing that beast.
> >=20
> > Adding i8042.reset=3D1 to the commandline fixed it.
>=20
> Wasn't there a quirk list where workarounds for i8042 on known bad machin=
es
> are stored? Maybe it would be a good idea to get your machine into it ;-)

Never heard of it. I'll see what I can find.

Regards,

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart6042013.TqJtlfO50o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjsm3N0y+n1M3mo0RAuHBAJsFzOYg7yziezWSYPQKu9EkkNOgGACg6Qhi
pv3eyoqTvioZbjqw1Y0TbW4=
=+59N
-----END PGP SIGNATURE-----

--nextPart6042013.TqJtlfO50o--
