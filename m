Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXGCFZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXGCFZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXGCFY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:24:59 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43486 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXGCFY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:24:58 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:24:57 +1000
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707031454.42078.nigel@nigel.suspend2.net> <20070703052130.GA17605@srcf.ucam.org>
In-Reply-To: <20070703052130.GA17605@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2457010.14VC3PiVMA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707031524.57572.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2457010.14VC3PiVMA
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 03 July 2007 15:21:30 Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 02:54:41PM +1000, Nigel Cunningham wrote:
>=20
> > Note, though, that this won't help at all when people use=20
the "suspend-to-ram=20
> > instead of powering down after writing a hibernation image" feature in=
=20
> > (uswsusp | tuxonice). Fuse is just a broken idea in the first place, bu=
t=20
> > given that it exists, we still need to find the underlying cause.
>=20
> If / is on fuse it's unlikely that hibernation is high on your list of=20
> priorities right now.

Yeah, well... what can you say to that? :)

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2457010.14VC3PiVMA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGid2pN0y+n1M3mo0RAmg9AJ9/zdXo11SYrq8FEYbkaJIF81BiKACeNyYv
NLrrYA9cmsw4R1bdi1Ka8Xo=
=3P8T
-----END PGP SIGNATURE-----

--nextPart2457010.14VC3PiVMA--
