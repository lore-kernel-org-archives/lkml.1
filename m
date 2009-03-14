Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZCPI3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZCPI3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCPI27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:28:59 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:46936 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCPI27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:28:59 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: No warning on resume with different kernel version
Date: Sat, 14 Mar 2009 16:28:59 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2554383.iIBWS5A5uR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903141629.05282.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2554383.iIBWS5A5uR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I'm sure this had worked before. And since I don't do that on a regular bas=
is,=20
but only by accident, I have no idea when it stopped working. But with my=20
2.6.28 kernel and everything more recent I don't get a warning if there is =
a=20
suspend image of a different kernel version, but simply the new kernel star=
ts=20
and throws everything away. Is this a kernel fault or something with the=20
userspace stuff? Whom to blame for this?

Greetings,

Eike

--nextPart2554383.iIBWS5A5uR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkm7zUEACgkQXKSJPmm5/E7DHQCfZj5UjSD3DILk+VpXG7qubnKG
bO4AoKYfk0SgJx6tTfjEu/X0yN23D16q
=g2II
-----END PGP SIGNATURE-----

--nextPart2554383.iIBWS5A5uR--
