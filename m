Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbZCMUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbZCMUH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbZCMUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:07:06 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58841 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbZCMUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:07:04 -0400
Date: Fri, 13 Mar 2009 21:06:57 +0100
From: Nico Schottelius <nico-linux-20090313@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ipw3945-devel@lists.sourceforge.net
Subject: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090313200657.GA4907@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090313@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I've two Lenovo X200 here, same config and same kernel version
(2.6.29-rc7-wl-ikn, from wireless-testing, v2.6.29-rc7-17155-g2f7ab92).

One reboots after half a second after displaying a message Probing for edd
(or similar). I tried with and without edd=3Doff, no changes.

The same happens with v2.6.29-rc7-32930-g5434dd7 (iwlwifi-2.6).

Anyone an idea, what maybe the reason for that behaviour?

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm6vOEACgkQuL75KpiFGIw0ogCdFtu1Tp+FGi0jqXMaxuv0vyvr
APwAoI/CHJ3ZB0nXan3fxNQd40NcXBvh
=u9su
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
