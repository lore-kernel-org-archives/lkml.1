Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0CMCLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:11:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60101 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0CMCLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:11:06 -0500
Date: Sat, 13 Mar 2010 03:11:01 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/base: init dynamic bin_attribute structures
Message-ID: <20100313021101.GB4034@pengutronix.de>
References: <1268377431-11671-1-git-send-email-w.sang@pengutronix.de> <1268377431-11671-3-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <1268377431-11671-3-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2010 at 08:03:50AM +0100, Wolfram Sang wrote:
> Commit 6992f5334995af474c2b58d010d08bc597f0f2fe introduced this requireme=
nt.
> Found with coccinelle, but fixed manually. Compile tested on X86 where
> possible.
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Eric W. Biederman <ebiederm@xmission.com>

Please drop in favor of http://lkml.org/lkml/2010/3/11/57

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkua9DUACgkQD27XaX1/VRt4EgCcDkrFBx0gQcvMGHD4mpq3zf1K
P8EAn35diMH9RZLuOB6U+QE0/1uoGEQF
=eSd+
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
