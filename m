Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYJEL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYJEL5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJEL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:57:06 -0400
Received: from msr4.hinet.net ([168.95.4.104]:41026 "EHLO msr4.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYJEL5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:57:04 -0400
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 07:56:56 EDT
Date: Sun, 5 Oct 2008 19:39:44 +0800
From: Kanru Chen <koster@debian.org.tw>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20081005113943.GA14320@atom>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Could you push a fix for this problem for .27 release? It seems many
people encounter this if they compile with PREEMPT enabled and it's quite
annoying.

Regards,
--=20
   ~    Kanru Chen <koster@debian.org.tw>
  'v'   http://stu.csie.ncnu.edu.tw/~kanru.96/
 // \\  GnuPG-Key ID: 365CC7A2
/(   )\ Fingerprint: 3278 DFB4 BB28 6E8C 9E1F  1ECB B1B7 5B5F 365C C7A2
 ^`~'^

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjop38ACgkQsbdbXzZcx6LlkgCfa7+wsbV1oKPwxX1WTiYPGyY8
j04AnR8VYVmTSdsqNapwgky/08TZ5962
=WmA1
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
