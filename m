Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYL0TWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYL0TWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYL0TVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:21:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56626 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYL0TVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:21:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Sat, 27 Dec 2008 14:21:52 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20081227184355.GA9264@uranus.ravnborg.org> <20081227185415.GA10361@uranus.ravnborg.org>
In-Reply-To: <20081227185415.GA10361@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2189064.WMM6D49aWe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812271421.53503.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2189064.WMM6D49aWe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 27 December 2008 13:54:15 Sam Ravnborg wrote:
> > And we need to get these fixed before we apply this patch.
> > Otherwise we will break every allyesconfig/allmodconfig builds
>
> I turned them into warnings for now.

i figured you'd choke when you saw the existing failure list :)
-mike

--nextPart2189064.WMM6D49aWe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVoBRAAoJEEFjO5/oN/WBE5EP/j0JEmWPP0CyuFqoUfLTgnNP
9lGzj8s4RbltEbvon94ohKQxdAUM4M+aRgke8RTHAtgJKmkdXtclIqh3j7nofEDj
B0YCbnH50CyzaKNibHOXXZ9EiaRHAQSuRupJkJKYt2dSycXIvPNTOnd/AwHs6j88
DLfnQoJWuFo04DFtjrvZvcCujhcJWmDir/OQXb6e5bYO+i5ouX8NBctsswHFLDXD
QCnAWmkcFgHhXJ2xdDdJKtmH0zwOJ4uDNM0dx9fUu+oyr349ntAh6JsaXg4r7QaY
BvSOUXH8KKn44Oj1HcGctebN4FQ3cPcCSmrWECufqXwpbfv+2KG82zaQ4H3llRz0
cfsIAYrYLconD9RonkN0wbss/m7tXT2dAJlTs66S9jVLa0wjSU2e1dGbNxib9v7G
iufZfSD9WaGHvxAFNrjTYVrnSMciZbg+yXFKK0r7cBQzrysKkmkdfqFqX3MWR6b+
ga1n8AVChIX7rbB6itULcyRz66nNOJymzWtK/A65uTaBfVVkL6T1IBDQsWsrQwrw
KgxIY/apvHm68Ufqkt8+N+iHwQUNtgeb9fKmgppGCsWYkH+GKqKffdg/d+a1bqvr
RLCysQWPIPQw7jGfkAYu86tMf+ofFgmD2A18JmIwW9HzKsUE2Dr/dX5QWV9zr3TX
EJwWuDX4vxQRVuPKw3LT
=vhBd
-----END PGP SIGNATURE-----

--nextPart2189064.WMM6D49aWe--
