Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZGFIkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZGFIkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZGFIki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:40:38 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:54146 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZGFIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:40:37 -0400
Date: Mon, 6 Jul 2009 10:35:51 +0200
From: Nico Schottelius <nico-linux-20090706@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20090706@schottelius.org>
Subject: 2.6.31-r2: Xorg: Black screen
Message-ID: <20090706083551.GA6422@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090706@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Compared to the other normal brightness problems, with
2.6.31-r2 xorg starts, but there is no image displayed
(neither on internal nor external monitor).

Switching back to console does not change the status,
though hitting ctrlaltdel reboots the system (i.e. still
up and running fine).

It works with 2.6.30-rc7 (besides sometimes the brightness
is broken there).

Sincerly,

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRt2YACgkQuL75KpiFGIzLqgCeMDZ57stKu7CceHnACKUOS4zQ
YiQAoL02TMIjfq6rJXUvqhljFSjft0z4
=SmDF
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
