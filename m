Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbYEAUjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbYEAUjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYEAUiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:38:54 -0400
Received: from mail.anarazel.de ([217.115.131.40]:47972 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbYEAUiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:38:54 -0400
From: Andres Freund <andres@anarazel.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION macro is used.
Date: Thu, 1 May 2008 22:38:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200805012005.42400.andres@anarazel.de> <200805012136.03569.andres@anarazel.de> <20080501194526.GP29330@cs181133002.pp.htv.fi>
In-Reply-To: <20080501194526.GP29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1771619.oArMhbuXEm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805012238.45090.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1771619.oArMhbuXEm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 01 May 2008, Adrian Bunk wrote in "Re: [PATCH] v4l/dvb: Add=20
linux/version.h include as KERNEL_VERSION macro is used.":

> > Hm. Strange.
> > It fixed a build error for me. Will retest and report back.
> It seems to be missing in another file.
> Can you send the error message and your .config?
Unfortunately no. I overwrote the .config with some other config and I coul=
dnt=20
reproduce the failure so far with a new config.
Sorry

Andres

--nextPart1771619.oArMhbuXEm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIGipVporPraT14igRAo2eAKCBtoYEm63FquiJxeMUOi23cK5jawCgjCXX
YUn/zqzDklx0suxD0A+tyCk=
=S26l
-----END PGP SIGNATURE-----

--nextPart1771619.oArMhbuXEm--
