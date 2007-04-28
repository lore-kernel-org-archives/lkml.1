Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbXD1LGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbXD1LGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXD1LGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:06:41 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:45589 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbXD1LGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:06:40 -0400
Date: Sat, 28 Apr 2007 13:06:52 +0200
From: markus reichelt <ml@mareichelt.de>
Subject: entropy of /dev/random vs. openssl rand
To: linux-crypto@nl.linux.org
Cc: linux-kernel@vger.kernel.org
Mail-followup-to: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Message-id: <20070428110652.GI13982@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-disposition: inline
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I need to create a moderate amount of v3 keys for loop-aes and wonder
how/if the "openssl rand" implementation differs significantly from
/dev/random concerning entropy.

In case /dev/random and "openssl rand" are somewhat comparable, I
would just use the latter to create the keys.

However, I certainly don't want to use a /dev/urandom look-alike.

Any feedback appreciated.

--=20
left blank, right bald

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGMyrMLMyTO8Kj/uQRAo2lAJ0UQndyKu7yIvKPESzkPBRVtpboQQCfYHqf
7P8qcer8lnWoEACPJGBN6+I=
=7ASw
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--

