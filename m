Return-Path: <linux-kernel-owner+w=401wt.eu-S1761850AbXGIQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761850AbXGIQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbXGIQ3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:29:02 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:42639 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759739AbXGIQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:28:59 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: "Peer Chen" <pchen@nvidia.com>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Mon, 9 Jul 2007 18:28:50 +0200
User-Agent: KMail/1.9.7
Cc: "Zoltan Boszormenyi" <zboszor@dunaweb.hu>, "kuan luo" <kuanluo@gmail.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, hancockr@shaw.ca,
       "Kuan Luo" <kluo@nvidia.com>
References: <53f198c00707060131x1e1abdd7l4396c7fede360970@mail.gmail.com> <468F41C6.3000109@dunaweb.hu> <15F501D1A78BD343BE8F4D8DB854566B15F9A3F5@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B15F9A3F5@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2943110.mjqRWZCF7Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707091828.55102.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2943110.mjqRWZCF7Z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 09 Juli 2007 schrieb Peer Chen:
> It's a rule for all our drivers not just for linux, also if we put the
> Maxtor drive to the blacklist so that its NCQ function won't be enable for
> all controllers of other vendors,but we don't have the strong evidence th=
at
> those Maxtor HDDs are also broken for other controllers.

The Maxtor drive I mentioned earlier worked fine on a ULI AHCI controller w=
ith=20
NCQ enabled for the few hours I used Linux on that machine for recovering=20
purposes.... So I wouldn't want a global balcklist.

BTW, I now have 4 Seagate ST3320620AS on the MCP51, mostly in raid5 and the=
y=20
work fine with NCQ enabled and the second patch you/your co-worker posted.

Cheers,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart2943110.mjqRWZCF7Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGkmJHxU2n/+9+t5gRAm1XAJ4nOuG/HAtTXyGavZB6VISh7U22rACg9mlv
2nDxcKUySGbRVt1LNIwZwsE=
=RDhQ
-----END PGP SIGNATURE-----

--nextPart2943110.mjqRWZCF7Z--
