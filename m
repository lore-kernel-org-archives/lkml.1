Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbZC3Ugs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbZC3Ugs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZC3Ugi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:36:38 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:52612 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZC3Ugh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:36:37 -0400
Date: Mon, 30 Mar 2009 22:36:19 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Reports about latest tested kernel versions
Message-ID: <20090330203619.GA5106@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-wl-36116-g6a982a0 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello developers, hackers,

as announced before, I'm collecting working (as in: boots and
is usable for normal usage) kernel configurations [0].

I'm regulary testing latest kernels in different trees and
reporting success of failure.

As I'm quite often manually reporting about (non-)working
kernel versions I thought about reporting it automatically
via the git post-receive hook (like [1]).

I'm wondering whether that would be some usefull or useless
information for you?

Sincerly,

Nico


[0]:
  http://git.schottelius.org/configs/linux/
  git://git.schottelius.org/configs/linux/=20
  http://git.schottelius.org/?p=3Dconfigs/linux;a=3Dsummary

[1]:
  http://l.schottelius.org/mailman/listinfo/commits

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknRLUMACgkQuL75KpiFGIw7MwCgrRreYHxJaX8+22u5QMV4ePuB
jwMAn1MdxE9W48mJuOQJFHgx2OUGB+5Y
=qO44
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
