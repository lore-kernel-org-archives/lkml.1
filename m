Return-Path: <linux-kernel-owner+w=401wt.eu-S936004AbYEVJeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936004AbYEVJeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbYEVJd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:33:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:57436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765837AbYEVJd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:33:56 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18sDclxSXcsFZzlQbfyAAR00LfYVmRt8arXvsa1xX
	zqK0lB+iJjmLGS
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 256 current references to "bad" CONFIG variables
Date: Thu, 22 May 2008 11:33:50 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1239871.ZdmnYbWxhO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805221133.53496.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1239871.ZdmnYbWxhO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

no advice, only a question:

Why do you use "DIR=3D${1-*}" instead of "DIR=3D${1:-*}" ?

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1239871.ZdmnYbWxhO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkg1PgEACgkQhyrlCH22naOVDQCfbyk+KsuqMQPbVHkk5i2Whcyn
edgAoMXH6tVV4jKEQkilQMqHqRPtjO/D
=aeZw
-----END PGP SIGNATURE-----

--nextPart1239871.ZdmnYbWxhO--
