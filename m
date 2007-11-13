Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbXKMMju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbXKMMju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXKMMjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:39:40 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:34243 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXKMMjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:39:39 -0500
Message-ID: <47399AFF.7040009@freedesktop.org>
Date: Tue, 13 Nov 2007 04:39:27 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Sparse 0.4.1 released
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig282CC6C74F817FF5396D3740"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig282CC6C74F817FF5396D3740
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have tagged and tarballed Sparse 0.4.1, now available from
<http://kernel.org/pub/software/devel/sparse/dist/sparse-0.4.1.tar.gz>,
with sha1sum `14085c5317cd7f2c8392fb762969906fa91888ef`.

This bugfix release fixes a Sparse assertion which recent Linux kernels s=
tarted
triggering, along with a few other fixes.

Several outstanding patches exist which need to go into the Sparse tree, =
but
this release does not contain those patches because people wouldn't have
had the opportunity to test them enough.

Full changelog:

Christopher Li (1):
      Perform local label lookup

Emil Medve (1):
      Handle ignored attribute malloc

Josh Triplett (4):
      Add comment on taint flags enum referencing expr->taint
      Add test-suite metadata to validation/local-label.c
      Add known-to-fail test case for a static forward declaration
      Makefile: VERSION=3D0.4.1

Mike Frysinger (1):
      fix install perms of manpages

Tilman Sauerbeck (1):
      Added a prototype for mempcpy().

-- Josh Triplett


--------------enig282CC6C74F817FF5396D3740
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHOZr/GJuZRtD+evsRAu4eAKCN2KkNVsuBs78U1urytpQVzWqCpwCePKe4
0VrCtoW8cmV0yK/9BPNTSoc=
=pqOj
-----END PGP SIGNATURE-----

--------------enig282CC6C74F817FF5396D3740--
