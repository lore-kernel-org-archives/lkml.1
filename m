Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbXETLiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbXETLiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXETLiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:38:03 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:41623 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbXETLiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:38:01 -0400
Date: Sun, 20 May 2007 13:08:15 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc (2)
Message-ID: <20070520110815.GD3253@aragorn.home.lxtec.de>
Mail-Followup-To: mingo@elte.hu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building 2.6.22-rc2 with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
kernel/time/ntp.c: In function 'do_adjtimex':
kernel/time/ntp.c:307: warning: comparison of distinct pointer types lacks =
a cast
kernel/time/ntp.c:310: warning: comparison of distinct pointer types lacks =
a cast
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way
  can be found to make it complex and wonderful ;-)

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUCwf3Ig8bsVPf7ARArikAJ9sqqOGRihVxbUuGCDkyfN5C/pJnACgtMg/
KglDl1XTxKgatFYYiUdg7C4=
=kg1q
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--
