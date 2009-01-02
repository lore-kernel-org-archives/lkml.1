Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZABIzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZABIzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZABIzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:55:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47169 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZABIzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:55:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: schwidefsky@de.ibm.com
Subject: Re: [PATCH] asm-s390/posix_types.h: drop __USE_ALL usage
Date: Fri, 2 Jan 2009 03:55:35 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
References: <1230882782-9977-1-git-send-email-vapier@gentoo.org> <1230886227.5474.0.camel@localhost>
In-Reply-To: <1230886227.5474.0.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2853479.VzoH07x2to";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901020355.37186.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2853479.VzoH07x2to
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 January 2009 03:50:27 Martin Schwidefsky wrote:
> On Fri, 2009-01-02 at 02:53 -0500, Mike Frysinger wrote:
> > Bring s390 in line with all the other ports.  Not sure how s390 missed
> > this change as all the other arches were being updated ...
>
> Should I carry the patch via git390?

i dont know what "git390" is, but it makes no difference to me how it gets=
=20
merged.  whatever is easiest for people.
=2Dmike

--nextPart2853479.VzoH07x2to
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXdaJAAoJEEFjO5/oN/WB8CYP/RqpchK2LMKUwxR4HjaqboMN
CiDMABPcAh5FT8OVdGc0Zwvy8G6XmyC2w1tKoz2ZK8QSoyL4bSar0nUKu2M4dW/h
39gbDmOaYvJl/1puoDvfuJrUWQR1DpUeBkinIpGRkEtPJLQdzQMtdJ5BHE7rnVWJ
nikrd5AkjYKci1v/ysGZD4FeLVSVa28EO17gvVIKnzGHThZ6DPtgsjve5zKT6R6X
xSRhBVcU83TOvrFllFhMiaV5X2WJOClRqtkPsYzaHJaQh0WQAn7OyQiip73ReG2W
+T5UFwbMboHDiGwYym8H/URnKw8nRdBYG0JwEIWVoqy7rdw60CGKq6r/2zLGIRtX
GX+ZDxSEP+uERAsmKGtGKrUbgoJyrFp11ztjxWFtGyQUu4GfQ5HSW2qNMUjBMm4o
O3uzFigyq1TdSLleSGYz8aselS4IjXbZzF8hfh1gA8jNtoWNuDFv89JOeYgCBvH8
59fNNVIecyhgbThAb43z4hOLu5QGc5HCYNg+glShjLo5L/Stp4yLO77k3dEq2hCm
JJSuLWabuXBsD9xh4s5oL8AC4KvaJSMVuy+XKmrpWo/6o7FEz29LiBuF1LQKMOo6
6QsmHXPxc26uPWyrA+uL8BWY4BkoS9GHutrgV1iDSNeXsoKdRVanq/sKvXDHT0Vc
cxw/R1QllR7xTBWySU1i
=qAZy
-----END PGP SIGNATURE-----

--nextPart2853479.VzoH07x2to--
