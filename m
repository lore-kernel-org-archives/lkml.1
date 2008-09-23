Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYIWMBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYIWMBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYIWMB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:01:26 -0400
Received: from postman.teamix.net ([194.150.191.120]:37883 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbYIWMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:01:25 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Date: Tue, 23 Sep 2008 14:01:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200809231101.41624.ms@teamix.de> <200809231348.50834.ms@teamix.de> <20080923115045.GG14840@elte.hu>
In-Reply-To: <20080923115045.GG14840@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6403999.Qa06ZPqXiW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231401.23432.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6403999.Qa06ZPqXiW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> * Martin Steigerwald <ms@teamix.de> wrote:
> > > please use -p1 to create patches - or since you've just set up the
> > > tip/master tracking, do something like:
> >
> > Okay, lets see how this works out.
> >
> > ---
> > From a57581d4ec3b13f63920b89c336ac9c93c6cf9f0 Mon Sep 17 00:00:00 2001
> > From: Martin Steigerwald <ms@teamix.de>
> > Date: Tue, 23 Sep 2008 13:45:46 +0200
> > Subject: [PATCH] CFS: Documentation about scheduling policies
>
> Applied to tip/sched/devel, merged it into tip/master and pushed the
> result out - thanks Martin.
>
> this was a perfect patch :)

Thanks. Now I can learn how I can update my local tip-master ;-). Hmmm, git=
=20
pull seemed to do the trick although it did not touch=20
Documentation/scheduler/sched-design-CFS.txt again. Seems it detected that =
I=20
applied the patch I sent you already.

Will it be in 2.6.28 or even in 2.6.27? 8-)

Looking forward to further documentation patches - these can't break any=20
code ;-).

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart6403999.Qa06ZPqXiW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjY2pMACgkQHhDFkwOZrpAHNQCgooqpTPnYuFff1RXymTzK6MJr
9MMAnRHnDtZR5m/OeTJdKzRUKaL5zfJG
=aE0Q
-----END PGP SIGNATURE-----

--nextPart6403999.Qa06ZPqXiW--
