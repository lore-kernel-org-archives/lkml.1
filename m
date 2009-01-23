Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbZAWJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbZAWJvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZAWJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:51:12 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:59036 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZAWJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:51:11 -0500
Date: Fri, 23 Jan 2009 10:51:08 +0100
From: Nico Schottelius <nico-linux-20090121@schottelius.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nico Schottelius <nico-linux-20090121@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc2: drivers/mfd/pcf50633-core.ko has undefined symbols
Message-ID: <20090123095107.GA4436@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090121@schottelius.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090121114432.GA4590@denkbrett.schottelius.org> <49791978.8080709@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <49791978.8080709@oracle.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc9-wl-denkbrett-24896-gf4f5c96 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Randy Dunlap [Thu, Jan 22, 2009 at 05:12:24PM -0800]:
> Nico Schottelius wrote:
> > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
>=20
> Patch is available & pull request has been sent to Linus, but he is
> traveling/at a conference/not merging patches at the moment.

Thanks for the information, will stick on old -wl tree for now.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl5kwsACgkQuL75KpiFGIwyWACgvnsbFoKtpBoNoS7fkVdbA0vt
OzQAoILmzux8oHkHGvajroOEmR6X7Sj/
=NrVO
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
