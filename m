Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYLZM4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYLZM4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 07:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLZM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 07:56:44 -0500
Received: from Powered.by.Root24.eu ([81.169.180.23]:37044 "EHLO Root24.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYLZM4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 07:56:43 -0500
Message-ID: <4954D478.8090408@ionic.de>
Date: Fri, 26 Dec 2008 13:56:24 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware errors with ipw2200 when connected to an WPA-enabled
 AP
References: <495443E6.404@ionic.de> <1230260706.27521.15.camel@debian>
In-Reply-To: <1230260706.27521.15.camel@debian>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig4FA4665B67323521F7AF0672"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4FA4665B67323521F7AF0672
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

* On 26.12.2008 04:05, Zhu Yi wrote:
> On Fri, 2008-12-26 at 10:39 +0800, Mihai Moldovan wrote:
>  =20
>> So, I am really curious about this, although not being fatal in
>> itself,
>> the errors are pretty annoying.
>>    =20
>
> The fatal error is from the perspective of the driver. It is handled
> transparent to the users now except the error logs.
>  =20

So is this all actually known and no bug? Whilst the connection drops in
idle mode are doing no harm, the sporadic problems on full load are some
sort of a problem because no traffic is transfered for some seconds,
although the connections per se remain intact.

Or... well, is this simply not fixable? :)

Best regards,


Mihai Moldovan


--------------enig4FA4665B67323521F7AF0672
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJVNSBAAoJEB/WLtluJTqHv88P/1QtiTstCufs79U4Pi3qSnki
2CDJRjcJ+01EvQK6cR9SlLp8PkjCDgIB6Lqfc5g1xTpjxZFHwgJH5Y8vp4fj/poO
jdEmyX5D+JLOBRblJWBza/957I+4uWj5BPLggTpkXQ8dsTnFW3J4nUKBtY2GpwAa
mptR1y0uAjnn3nCQnZBGVCE44SWAVsnLqQkVhHq++3pT1y9PofXZsXaY6Y3LMSwR
fW+ykAhmlaGJrLmELjAfgOZQNG2YTK9vy9bOjTfkmdToXngcmbww7gWGhrEOeUAa
WizxRN35+VBf3rpDVPI0Zx+CxFnpo7hTn5yyQ/uEAFbzvISV5If3B9xRUMNrVTHu
CuA68jo4fuIH+yi1tBZUPDMJyVRs7nN4c5RlH1N2M2RVfEnXyOiRP2SfJM/pHrEB
yNbEKdIZGAGjSlNuJ6lTL0XyD+nt/SLvVOwu2t1ffmRQ+t3joS7qgJWsaEc7tBUi
3/awSrO0kRpDipO4RvULrhLfnBqY1TQedpcVyDEO2vwLfV400EGbhDLTD24xW+UN
MeMg9ewRx4g0m65mFFxy0++Nx8XDSre+Q5/exURTQL9kMsst0YL8p5WKl6QZH1dR
OvTEQozC125cribKVQUz5zD3jRcV6OO79vJfpDPZT3GQ5l+AkEZKvpOiKzKu6y3n
pgCc5yvhWENhV0YeGkfm
=3u4O
-----END PGP SIGNATURE-----

--------------enig4FA4665B67323521F7AF0672--
