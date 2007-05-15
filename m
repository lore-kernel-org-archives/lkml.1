Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXEOVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXEOVR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbXEOVRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:17:15 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:54921 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbXEOVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:17:14 -0400
Date: Tue, 15 May 2007 23:16:42 +0200
From: markus reichelt <ml@mareichelt.de>
Subject: Re: Announce loop-AES-v3.2a file/swap crypto package
In-reply-to: <4649F5DC.87043316@users.sourceforge.net>
To: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Mail-followup-to: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Message-id: <20070515211642.GA1058@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=Kj7319i9nmIyA2yE
Content-disposition: inline
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
References: <4649F5DC.87043316@users.sourceforge.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jari Ruusu <jariruusu@users.sourceforge.net> wrote:

> loop-AES changes since previous release:
> - loop_twofish.c loop_serpent.c loop_blowfish.c modules included.
>   They are not built by default. Add EXTRA_CIPHERS=3Dy make parameter
>   to build them.

Just curious, will the ciphers package also be continued/available
separately as before or is it merged from now on into the loop-aes
package?


--=20
left blank, right bald

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGSiM6LMyTO8Kj/uQRAgTcAJ4vVlVBhDS29vwsDoBNNhdrhIWkuQCfYfSm
2aFWm6FlxBGhtevH9ojub78=
=IvrL
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--

