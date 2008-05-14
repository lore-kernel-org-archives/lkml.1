Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYENMA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYENMA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYENMAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:00:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35562 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbYENMAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:00:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: maximilian attems <max@stro.at>
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Date: Wed, 14 May 2008 08:00:43 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, debian-kernel@lists.debian.org
References: <20080514110531.GA11775@stro.at>
In-Reply-To: <20080514110531.GA11775@stro.at>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5490017.hvedZytEkg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805140800.44608.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5490017.hvedZytEkg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 14 May 2008, maximilian attems wrote:
> could we please get an ack or nack on that patch.

it's already been added to linux-mm
-mike

--nextPart5490017.hvedZytEkg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUASCrUbEFjO5/oN/WBAQJwDhAA5cYnB6lA5huqA9Ptnwf7x+t/pEH+VDJo
Yf9FiiU8ZCGN+2mW4k3iiiSinK/sbweTtxR/PmPnlpOPk8Vv/6F429jiWmgra2IV
m4+u1zjee7EHx7tRtohglAbz48pnm/DiM+GU87Eg0xR5dx97t4n6+HlzjRcA0LJU
LY4fEKMUkzAvyOm96QZvKLsPSIrjtlCUXFTjRQeUD8MDuUMpbbYKeXmaeQVD702K
dWmrODwU86uxiwXTXMAhvR+qb3AjyDZpbPuXWNJmoJ9G26g7G9tvU3Vl4RffpVkB
51Fb0rhqIWkg+HIAMOR5QmfMN7RnOwm2pzWTVYvYz0zGpuLfUOjbK8NC7mw8fWSF
CBr78bjRvjzoBp+CjPJvV2B9izVHMY6DRdy4Ypbnwgx4FkESroqyqY92oDTw4/BE
0coj2Eg6PFCxdbIwBIeCNjU4ol9eQY2Sfzz2NS/XSHcuiT0OzytKCYFtPt06jrXD
Qtg9wAnsenKUc9sEczjDtmomx0Rh8WoRYlVVTWOaDRoCVDUjjmqiQm526BmMe+XL
tPkEyB2l25K7pHAHyE/MkNJ1U//YC1l/OVEuFXYzwV2O4wMbsP7GAPO1qXEdP4bE
B2kt7omTVD63/xgjCVssZ9yQ0ZuFn/1/OmvAtzYaDgxb+XJ/87oNDjSSH6pT18YN
9NS2ahqZhOw=
=+M5c
-----END PGP SIGNATURE-----

--nextPart5490017.hvedZytEkg--
