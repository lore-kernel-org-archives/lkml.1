Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYBISLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYBISLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYBISL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:11:29 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:49067 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755440AbYBISL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:11:28 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 19:11:25 +0100
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <20080209141852.GC22569@one.firstfloor.org> <200802091302.51863.gene.heskett@gmail.com>
In-Reply-To: <200802091302.51863.gene.heskett@gmail.com>
MIME-Version: 1.0
Message-Id: <200802091911.25730.prakash@punnoor.de>
Content-Type: multipart/signed;
  boundary="nextPart1313343.GUVkYT5ZL9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1313343.GUVkYT5ZL9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Saturday 09 February 2008 Gene Heskett hast written:
> This has killed me both at boot time twice, once before NASH was running,
> and several times when uptimes were a day plus, but has never reappeared
> since the first time I used the acpi_user_timer_override argument, and th=
is
> includes several boots without it including 2 complete, 2 or 3 minute pow=
er
> downs.

Are you saying that on your nforce2 you need the override=20
(acpi_use_timer_override) to have a stable system? Because that would be in=
=20
contrast to all previous findings regarding nforce2. Could you provide=20

cat /proc/interrupts
lspci
lspci -n
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1313343.GUVkYT5ZL9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrezNxU2n/+9+t5gRAhJ8AKDUWeuhtXIRtZi6niPBTU9ZX+7avQCgw+Mi
ajTnOAkBFd35PsL0EzNLIMw=
=xOEQ
-----END PGP SIGNATURE-----

--nextPart1313343.GUVkYT5ZL9--
