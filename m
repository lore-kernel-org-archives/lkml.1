Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZFGVLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZFGVLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZFGVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:11:10 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44794 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZFGVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:11:10 -0400
Message-ID: <4A2C2CE5.4010909@tuxteam.com>
Date: Sun, 07 Jun 2009 17:11:01 -0400
From: David Tomaschik <david@tuxteam.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel Slowdown without Swap Space?
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://key.webgroup.org
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E3841FC6C92FE02E0D9C9AC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E3841FC6C92FE02E0D9C9AC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

It has frequently reported in a number of sources that running a Linux
system without any swap slows the kernel down.  While I understand that
the overall system may run better with swap (unused space can be swapped
out to allow more cache), is there any reason a significant performance
hit would be seen when running without swap?  I currently do so on my
netbook (to reduce write cycles to the SSD).  So is the "need" for swap
urban legend, or is there a good case for it, aside from caching
performance?

Thanks,
--DT


--------------enig1E3841FC6C92FE02E0D9C9AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKLCzqAAoJEIjVcBRtQoaVWZUP/A0oJGCgkOBerN2wFKdrWxF/
j04stD9vTd3sit5z2pa87XI2IYR6jfTB5oZA2U35aGh5CydyyrxEpJMVQCpH0dS0
ThVK/NxO0tx0QnsTWOynFBoW5eDFhpa4nCXShYePrev0sDSrRwcj8q46Ao3HKTwq
k5hl6ycqqglJaejf9ljO4FeOxUBgdRhyNTtNRukhO/NYki6XZT4uLqLTFe12qd0U
WJdPuVpCFCIkIiHwwuyUpVtR0GJguW3U/FfS21wPdkiF5ocKlT6Z6r88KsCjahf/
m/Dc+XdcgV6V2ox0DqHdx7k+vADBHCCqHRJmBs6qAWh6241Z5JUev4vUpcNckDEz
hitCz0LkK19yoFvjJlEW2Esw+GyXqrI71o4tnrGx9rMYBFPtpSBlR0VYRA+gZFiP
GVpkC5FvMF7QDeGFamvS1IKd1OMF81DKg1j9mjN3wgXpshCObjjOAIHkeJCBe1sp
DzhQtNxLIHp18Tvokw0dL33u7VPXsQZZGBGvJb2Cxwe0rmf/io57rlG4gGJdiaHG
a8Mkh6UMDxuQQOtrEX8fZRmihfod68YsOLOiSskq8mKWsg5UVQI7I71R7iWBc9F6
kMHI0XYVVe5ZvS0CwKPdBix4CkAl/hwbqajsNT+5LqRYmvJXXgn0UcDLXNWCuDqw
elLep0STaIEmFyXksn5a
=Z+4J
-----END PGP SIGNATURE-----

--------------enig1E3841FC6C92FE02E0D9C9AC--
