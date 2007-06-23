Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXFWSOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXFWSOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbXFWSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:13:56 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:21445 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbXFWSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:13:55 -0400
From: Wolfgang Draxinger <wdraxinger@darkstargames.de>
Organization: DARKSTARgames
To: linux-kernel@vger.kernel.org
Subject: Linux on XScale 270
Date: Sat, 23 Jun 2007 16:18:33 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1970915.g8ERNy1ifn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706231618.44659.wdraxinger@darkstargames.de>
X-RZG-AUTH: lUARs4syB/PlPtd0/+TQzrPn6nwm8890uPigqpH5turBXxZleD56tijuMSK4YRDcwTZs9LGxhFzph5k=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1970915.g8ERNy1ifn
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Typing "Linux XScale 270 or 27x" brings you a lot of pages but not an=20
in depth doc/HOWTO how to compile your own kernel and make a boot=20
image for that arch. The vendor from which I get the XScale sponsored=20
has ready to use Linux images and source on his webpage, but they're=20
kinda old and dusty.
http://www.toradex.ch/colibri_downloads/Linux/

So what are the steps I've to take, to get a Linux Kernel on a XScale?=20
It's obvious that I need a cross compiler for ARM, bootloader images=20
and so on, but it's the gory details I'm curios about.

Links to HOWTOs, documentation highly appreciated. And probably=20
there's also a better suited maillist than LKML for this, to a=20
pointer to that (if existing) would be nice, too.

Thanks in advance

Wolfgang

--nextPart1970915.g8ERNy1ifn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGfSvEBfWmRR/TvT4RAl6sAKDK3ri/ASCOHmhBqEPFTJFnRgJ6fQCfRkGd
XbsQPs8ZCDDm8D4e125OLIQ=
=JMVJ
-----END PGP SIGNATURE-----

--nextPart1970915.g8ERNy1ifn--
