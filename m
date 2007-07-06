Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXGFHPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXGFHPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbXGFHPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:15:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35730 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760210AbXGFHPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:15:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: DervishD <lkml@dervishd.net>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Date: Fri, 6 Jul 2007 03:17:33 -0400
User-Agent: KMail/1.9.7
Cc: Nix <nix@esperi.org.uk>, Bodo Eggert <7eggert@gmx.de>,
       Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <87vecyeg5y.fsf@hades.wkstn.nix> <20070706064153.GA25161@DervishD>
In-Reply-To: <20070706064153.GA25161@DervishD>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1909414.D37Cfd0V8l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707060317.35177.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1909414.D37Cfd0V8l
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 06 July 2007, DervishD wrote:
>     I really like the spirit of CMake. Of course, it adds a dependency,
> but IMHO is much safer to depend on CMake being installed (or Perl, for
> that matter) than to depend on a shell. Every shell out there seems to
> do things on its own, and apart from dash, which is more or less
> standard, the rest of shells do actually violate the standard one way or
> another (in fact, configure script include workarounds for at least Bash
> and Zsh).

careful, you tread into dangerous territory making silly statements like th=
at. =20
by "standard" you probably mean "POSIX standard" which dash too has had=20
plenty of bugs in terms of implementing it properly (and still does).  as f=
or=20
the workarounds you allude to, autotools is designed to be portable=20
everywhere which means including workarounds for random bugs in major=20
releases of operating systems.  just because autotools lacks workarounds fo=
r=20
bugs found in random versions of dash does not make dash magical.  there is=
=20
also the fact that autotools works on systems that predate POSIX or lack=20
shells which support POSIX.  and claiming that it's safer to depend on CMak=
e=20
than bash in this Linux world is just plain bogus.
=2Dmike

--nextPart1909414.D37Cfd0V8l
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARo3sj0FjO5/oN/WBAQKf6A//eETco2XU+hjk/C4AQZaG4y2CD3D64vGO
AzYoK0H1bVg0x1+q1FZsTlJF/fpz4FXcD6BrFN7hYI95ltEOIJ24aVHKS3GyaNqY
/LqOezOq40r/napQ/e9qZ2ojfOsvd4M1JVAaS5SUe64Q5Idhk7piX1aCLfJw5JTS
Zhx9hhMByKU4eAhJiiDf0wq4PIFmI8EXWMxsKpsQHm6EdWwzj03ofmu7/1HiisNm
2MiyaddlfqDNgSjQFWuWXvsLEYtNZIcGpnWl5Kh+u2fNP0qZuDlwXGZ9Zq7jWZcK
q4iiqUQxg7dssYNXgQb0XqJZvcFe2emAXv6LgvyhRl4TYLjB3dXj/AnLckdag7VH
eCGPFqECZcKBdvBo2Ik6Nh68dgtwwyjJ/VbdIVhyqeO3wCFYarYaRuDoZoGnpcq6
ArCGUI25+7nN+OhjlO1WWzBazfK1crLGstF8f6oCxoITYklgO8GWnH/LF85ZoKmG
TI+8Cd7fzJe/ITQBbGNbAX9rX28T35LMoGPjhnhlL6jkDc+t9Bz7Xi9nvmDnPwa6
SpBLlJxXwuI/HuS7CAYvqUxXPWoGHSgiVYEL1+5xjZblcRmTQCdOwWvu1h5kllHu
+Dqr+RQvBTJ1jdKNJ9rUOWW2QDwz3JsO+u2qS7ce7Y15k/Kl6F+FvjD/kx1fW5td
+F8+0a3PFuk=
=EC+6
-----END PGP SIGNATURE-----

--nextPart1909414.D37Cfd0V8l--
