Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZGHVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZGHVEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZGHVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:04:30 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:50871 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZGHVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:04:29 -0400
Date: Wed, 8 Jul 2009 23:04:15 +0200
From: Nico Schottelius <nico-linux-20090706@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nico Schottelius <nico-linux-20090706@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-r2: Xorg: Black screen
Message-ID: <20090708210415.GB26674@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090706@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090706083551.GA6422@ikn.schottelius.org> <20090706105249.307e4a6b@jbarnes-g45>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <20090706105249.307e4a6b@jbarnes-g45>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jesse Barnes [Mon, Jul 06, 2009 at 10:52:49AM -0700]:
> On Mon, 6 Jul 2009 10:35:51 +0200
> Nico Schottelius <nico-linux-20090706@schottelius.org> wrote:
>=20
> > Hello!
> >=20
> > Compared to the other normal brightness problems, with
> > 2.6.31-r2 xorg starts, but there is no image displayed
> > (neither on internal nor external monitor).
> >=20
> > Switching back to console does not change the status,
> > though hitting ctrlaltdel reboots the system (i.e. still
> > up and running fine).
> >=20
> > It works with 2.6.30-rc7 (besides sometimes the brightness
> > is broken there).
>=20
> Can you bisect?

Sorry, currently I'm bound to using that computer for work.
Maybe I can give it a try next week (holidays).

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpVCc8ACgkQuL75KpiFGIyMmACfdWBPXewjrdLg1T4nxUOwYS2H
23EAnA9+6jNM4gcPe9Gf6XAP96UnhZbc
=eVNN
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
