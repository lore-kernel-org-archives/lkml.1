Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXGBHbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXGBHbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 03:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXGBHaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 03:30:55 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60469 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXGBHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 03:30:55 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: LKML <linux-kernel@vger.kernel.org>
Subject: Suspend2 is getting a new name.
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Date: Mon, 2 Jul 2007 17:30:56 +1000
Content-Type: multipart/signed;
  boundary="nextPart4365828.Xalgg0LzGX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707021730.57066.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4365828.Xalgg0LzGX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all.

Suspend2's name is changing to "TuxOnIce".

This is for a couple of reasons:

In recent discussions on LKML, the point was made that the word "Suspend" i=
s=20
confusing. It is used to refer to both suspending to disk and suspending to=
=20
ram. Life will be simpler if we more clearly differentiate the two.

The name Suspend2 came about a couple of years ago when we made the 2.0=20
release and started self-hosting. If we ever get to a 3.0 release, the name=
=20
could become even more confusing! (And there are already problems with peop=
le=20
confusing the name with swsusp and talking about uswsusp as version 3!).

http://www.suspend2.net is still working at the moment, but we'll shift to=
=20
http://www.tuxonice.net over the next while. The wiki and bugzilla are=20
already done; email will remain on suspend2.net for a little while and git=
=20
trees will be renamed at the time of the next stable release.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart4365828.Xalgg0LzGX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGiKmxN0y+n1M3mo0RAhUIAJ92msMGmDSye72Zg+R4u1lEAmbt5QCfV2Mo
Ilnd8geH9mmfAnlfcANX8AY=
=V4u6
-----END PGP SIGNATURE-----

--nextPart4365828.Xalgg0LzGX--
