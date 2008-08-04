Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYHDXhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYHDXhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYHDXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:37:23 -0400
Received: from mx2.schottelius.org ([62.65.138.77]:42616 "EHLO
	mx2.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYHDXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:37:21 -0400
Date: Tue, 5 Aug 2008 01:37:12 +0200
From: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Message-ID: <20080804233712.GA4181@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-kernel-bugreport20080731@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20080731210507.GA6094@denkbrett.schottelius.org> <20080804090654.GA4747@denkbrett.schottelius.org> <20080804161443.GA4905@denkbrett.schottelius.org> <200808042132.41020.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <200808042132.41020.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett (Linux 2.6.26-next-20080725-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Mon, Aug 04, 2008 at 09:32:40PM +0200]:
> On Monday, 4 of August 2008, Nico Schottelius wrote:
> >=20
> > I retested it with linux-next + updates from its branches
> > (=3D2.6.27-rc1-next-20080804-denkbrett-03792-g1d2be1a)
>=20
> Well, fine, but this is not exactly helpful.
>=20
> Can you test the current Linus' tree with the patch from bug #11178, plea=
se?

I am using 2.6.27-rc1-denkbrett-00555-g8f616cd-dirty now, latest fetch
=66rom Linus' tree + the patch and the problem is the same: Wakeup works,
but screen keeps on being blank.

I am running next-20080725 now again, which works.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiXkqgACgkQuL75KpiFGIw3VACdHcmeaD6mNROGVDMjKICDzi7d
Hg8AoJcGXlud3LUtTMpbEk9FePiFgDJO
=OHEx
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
