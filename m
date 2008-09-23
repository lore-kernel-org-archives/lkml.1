Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYIWJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYIWJxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYIWJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:53:09 -0400
Received: from postman.teamix.net ([194.150.191.120]:54528 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbYIWJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:53:08 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Date: Tue, 23 Sep 2008 11:53:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200809231101.41624.ms@teamix.de> <20080923091159.GE31189@elte.hu>
In-Reply-To: <20080923091159.GE31189@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2130698.tltOMmctJG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231153.04035.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2130698.tltOMmctJG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> * Martin Steigerwald <ms@teamix.de> wrote:
> > The documentation about the CFS scheduler is scarse when it comes to
> > scheduling policies. This patch adds a chapter about the scheduling
> > policies it supports. Peter Zijlstra provided most of the information f=
or
> > it in
> >
> > http://marc.info/?l=3Dlinux-kernel&m=3D122210038326356&w=3D2
> >
> > This patch is based on 2.6.27-rc7.
> >
> > Signed-off-by: Martin Steigerwald <ms@teamix.de>
>
> looks good to me - but could you please do the patch against the latest
> scheduler tree, which has already updated this file (and which made your
> patch not apply cleanly):
>
>   http://people.redhat.com/mingo/tip.git/README

Should I use=20

checkout -b tip-latest tip/master

as described in the README or tip/sched/devel or even something else?

I am new to git. I know Bazaar quite well however, so I am not compeltely n=
ew=20
to DVCS.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart2130698.tltOMmctJG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjYvH8ACgkQHhDFkwOZrpBncACfVviTTyws576CozUqsc4a2y/M
ufQAoJg49YsPykYBGxzR7I66G4i5vAkr
=8v2C
-----END PGP SIGNATURE-----

--nextPart2130698.tltOMmctJG--
