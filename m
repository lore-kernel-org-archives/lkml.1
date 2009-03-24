Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbZCXQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbZCXQsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760973AbZCXQro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:47:44 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:39533 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466AbZCXQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:47:39 -0400
Date: Tue, 24 Mar 2009 17:47:36 +0100
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090324164735.GA5495@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	Nico Schottelius <nico-linux-20090313@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
References: <20090313200657.GA4907@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20090313200657.GA4907@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Nico Schottelius [Fri, Mar 13, 2009 at 09:06:57PM +0100]:
>=20
> I've two Lenovo X200 here, same config and same kernel version
> (2.6.29-rc7-wl-ikn, from wireless-testing, v2.6.29-rc7-17155-g2f7ab92).
>=20
> One reboots after half a second after displaying a message Probing for edd
> (or similar). I tried with and without edd=3Doff, no changes.
>=20
> The same happens with v2.6.29-rc7-32930-g5434dd7 (iwlwifi-2.6).

It works again with 2.6.29 (linux-2.6) and next-20090324 (which
is otherwise broken)!

Will test iwlwifi & wireless-testing in the next days.

So it was definitely a kernel issue and not userspace.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknJDqYACgkQuL75KpiFGIx8tgCfaIGIoatdR1Vlfcu57xmlNPyT
DqgAoJcBSM5CLuSumq6FbLYNLzdMZrQS
=79O3
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
