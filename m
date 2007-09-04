Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXIDQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXIDQVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXIDQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:21:08 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:47150 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbXIDQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:21:06 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc5
Date: Tue, 4 Sep 2007 18:20:47 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <200709020954.08285.prakash@punnoor.de>
In-Reply-To: <200709020954.08285.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1398238.VqLXGQ9tUN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709041820.51292.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1398238.VqLXGQ9tUN
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Sunday 02 September 2007 Prakash Punnoor hast written:
> Hi,
>
> 2.6.23-rc5 locks up hard (Magic Syskeys won't even work) after a few
> minutes of work on x86_64. 2.6.23-rc4 was fine. I'll try git-bisect to fi=
nd
> out what is causing trouble. Yes, I am using nvidia binary but it didn't
> make troubles since ages... When I found the bugger, I'll try whether it
> works w/o nvidia binary.

It seems my system is stable again with patch from

http://lkml.org/lkml/2007/9/2/219

Though I didn't get a light show on hang...

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1398238.VqLXGQ9tUN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBG3YXjxU2n/+9+t5gRAosZAJ9EMGI7mDWl0K8UCUxKom2oL7AL8gCg59v2
lMzAYXNaCo8rKHsyURRdgb0=
=vB1A
-----END PGP SIGNATURE-----

--nextPart1398238.VqLXGQ9tUN--
