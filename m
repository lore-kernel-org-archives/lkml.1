Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXGIHZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXGIHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXGIHZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:25:48 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:59491 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbXGIHZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:25:47 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] misc patches
Date: Sun, 8 Jul 2007 17:53:56 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3201561.cZ52C6KGn3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707081754.03824.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3201561.cZ52C6KGn3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This are some random patches I've lying around here. They are not related t=
o=20
each other

1) Use kcalloc() in drivers/video/aty/atyfb_base.c
2) Initialize filp->private_data only once in em28xx_v4l2_open
3) [Doc] Fix typos in fs/sysfs/file.c
4) [Doc] Document pci_iomap()

Eike

--nextPart3201561.cZ52C6KGn3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGkQibXKSJPmm5/E4RAhWwAJ4oA/EpS+nwgmRZ0KavsKmJgYlYMwCgoBnI
8F+J0IiqPkzQAMEoYmsHHTs=
=drG4
-----END PGP SIGNATURE-----

--nextPart3201561.cZ52C6KGn3--
