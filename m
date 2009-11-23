Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZKWPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZKWPyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZKWPyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:54:16 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZKWPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:54:16 -0500
Subject: Re: [PATCH] Fixed bug in Wireless Extension Code
 (CONFIG_WEXT_CORE).
From: Johannes Berg <johannes@sipsolutions.net>
To: mike@mspradling.com
Cc: davem@davemloft.net, hugh.dickins@ticali.co.uk, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091123154225.GA26103@MSServer>
References: <1258936602-6110-1-git-send-email-mike@mspradling.com>
	 <1258969541.7094.138.camel@johannes.local>
	 <20091123154225.GA26103@MSServer>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JPQRH8OzDM0VlCEdBEKn"
Date: Mon, 23 Nov 2009 16:53:46 +0100
Message-ID: <1258991626.7094.174.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JPQRH8OzDM0VlCEdBEKn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 10:42 -0500, Michael Spradling wrote:
> I don't think its a Kconfig issue, see notes below.  However,
> I have included my config file just in case I may be wrong.

You config file doesn't have _any_ wireless options set. Not even
CONFIG_NET.

johannes

--=-JPQRH8OzDM0VlCEdBEKn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCrAHAAoJEODzc/N7+Qma4NkP/A1yPNgSYbHBCDokP20si9KW
UXfG8Rmbdb378eRWIt3hmKE96vouCZkcka0uqbn/iILprofnVXBwnGKR/FqNA6zt
AgF78zJQ/QXczPd43Z3vvGrqbq0altYmXbmuWY6v4TQHOWQzA9dUHkcmyJ9DTd9P
PfjwStT4jso7zccaj0prHPG7SyAZB15vrBee7RvRK492BX+zPCAs5QjRLOYOynq3
aj8tuDxXGW+K0uNOcj/1AZtYn0pusdD+0D8WYWQWTNT9caOpy8jMTZEGg89WGlYm
YO3gN281gRRblwfbg1hHfCCMh6xXoLW8WGzCgOXmvSW87bdHzenKy5eBX7JWcXD3
mZIxz38gDSmHglbBegtcHUpWawgZceiASLxE/fV0mgJVdYCMfrvjSZvpfoSf8pge
jgtpWhnrLIjO9kSZqAxeB+4ZACjXhbzSW+fz0qt+oMslwPLomsA2Ts7hejfYw7nG
y3s5Sqx3WaCAFDltvDClteK5cjbKofCLLO0lL6WwxquvOUx6eiO+oWjqV0c9aGFo
sREDbyriXFe+F8C+Sq6cjI/UCwqPV5groUmke3P3b7hlSkIN5ePkEfo04q+cgiJQ
0ViJifbuHlA2A+Z4kiluKn2YTBZs9s51u4Wd/jSMHkHurRtG67f69MHNWqPfw6UN
MKfQ529PQ0c8dVgFz+5R
=FshL
-----END PGP SIGNATURE-----

--=-JPQRH8OzDM0VlCEdBEKn--

