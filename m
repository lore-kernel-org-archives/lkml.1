Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZFSNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZFSNpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZFSNpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:45:47 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36309 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZFSNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:45:46 -0400
Date: Fri, 19 Jun 2009 15:44:37 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 19
Message-ID: <20090619134437.GA10571@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20090619172622.05adb236.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-07040-g0732f87 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Stephen Rothwell [Fri, Jun 19, 2009 at 05:26:22PM +1000]:
> Hi all,
>=20
> Changes since 20090618:

This one stops my boot process, when trying to startup
uml-utilities. 2.6.30-07040-g0732f87 (linus) works.

amd64, config attached.

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko7lkUACgkQuL75KpiFGIyO0ACfQYyAOuq5jQoLHUcp2Ok0JvDF
1IUAn0jgvcO2PrNoRL6FnTITh2ffQEYt
=pQT1
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
