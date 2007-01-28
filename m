Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXA1LFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXA1LFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 06:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXA1LFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 06:05:17 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:38227 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbXA1LFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 06:05:16 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: [PATCH] nvidiafb: allow ignoring EDID info
Date: Sun, 28 Jan 2007 12:05:09 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <ephv35$4i3$1@sea.gmane.org>
In-Reply-To: <ephv35$4i3$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1174971.eNndTCJJu1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701281205.13078.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1174971.eNndTCJJu1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 28 Januar 2007 schrieb Giuseppe Bilotta:
> From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

> Solve the issue by introducing a new boolean module parameter (useedid)
> which can be set to 0 to prevent the driver from using the EDID
> information.

I don't know whether this is possible, but wouldn't be a cleaner approach b=
e=20
to put this parameter to something fb specific and not nvidia specific? As=
=20
Nvidia fb proabably isn't the only one using edid and so it wouldn't be=20
necessary to introduce such a parameter for every fb driver...

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1174971.eNndTCJJu1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFvINpxU2n/+9+t5gRAgHQAKDYLyO87C1UGP6UjASuvRYiQKuhLACfVZal
YEjvm/quHNHFCaY2Nen4CLQ=
=U6bx
-----END PGP SIGNATURE-----

--nextPart1174971.eNndTCJJu1--
