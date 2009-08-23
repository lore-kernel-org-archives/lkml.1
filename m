Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbZHWNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbZHWNdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbZHWNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:33:00 -0400
Received: from smurf.noris.de ([192.109.102.42]:30440 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934036AbZHWNc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:32:58 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2009 09:32:56 EDT
Subject: Re: [PATCH v2] scripts: add typdef removal tool
From: Matthias Urlichs <matthias@urlichs.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
In-Reply-To: <4A8E5F73.6010904@gmail.com>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
	 <20090817060203.GL5039@cr0.nay.redhat.com>  <4A8E5F73.6010904@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UkhDqskoI9+zruC36Dg/"
Organization: {M:U} IT Design
Date: Sun, 23 Aug 2009 15:09:10 +0200
Message-Id: <1251032950.10339.1101.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UkhDqskoI9+zruC36Dg/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 10:48 +0200, Jiri Slaby wrote:
> >> +if [[ $# -lt 3 ]]; then
>=20
> Could that be [ ] instead of [[ ]]?
>=20
Yes. In fact, it should be, as [[ ]] is a bashism.

--=-UkhDqskoI9+zruC36Dg/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqRP3YACgkQ8+hUANcKr/m7ngCgpMSYtaDwEFThIQ2TRdThoLDV
XDoAn206FdyCj9ow7TF7O4DOdy//b+67
=v64d
-----END PGP SIGNATURE-----

--=-UkhDqskoI9+zruC36Dg/--

