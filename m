Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZGALP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZGALP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZGALPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:15:20 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:48925 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZGALPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:15:19 -0400
Date: Wed, 1 Jul 2009 13:13:35 +0200
From: Nico -telmich- Schottelius <nico-linux-20090625@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Resume fails on 2.6.30-rc3-00340-gce8a742
Message-ID: <20090701111335.GB26429@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-20090625@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning!

Using this version, suspend to ram works, but the X200 (amd64)
will never awake.

Working version: 2.6.30-rc7

Will test more recent versions in the next days.

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLRN8ACgkQuL75KpiFGIybEgCgxzy6p/S6JUI1iJ2imDrmwDMh
29YAn1F0ZTJMPpZWd4jhBMHhMEwLF8+k
=zq2R
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
