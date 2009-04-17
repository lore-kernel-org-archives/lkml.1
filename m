Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZDQVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZDQVeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZDQVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:34:41 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:35788 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZDQVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:34:41 -0400
Date: Fri, 17 Apr 2009 23:34:36 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Nico Schottelius <nico-linux-20090330@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [Resend] [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090417213436.GA16933@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jiri Kosina <jkosina@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
References: <20090330122137.GA6918@denkbrett.schottelius.org> <20090407154437.GA31758@ikn.schottelius.org> <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de> <20090407174550.GB13089@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20090407174550.GB13089@uranus.ravnborg.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-wl-36123-g39fb448 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Sam,

Sam Ravnborg [Tue, Apr 07, 2009 at 07:45:50PM +0200]:
> On Tue, Apr 07, 2009 at 05:56:31PM +0200, Jiri Kosina wrote:
> > On Tue, 7 Apr 2009, Nico Schottelius wrote:
> >=20
> > >   git://git.schottelius.org/linux/linux-2.6
> > >=20
> > > if you want the patch (f43ba0be1204e7c26cc700a75bdb688a788fbf2f)
> > > via git.
> >=20
> > This patch isn't trivial enough to be applicable through trivial tree.=
=20
> > Adding Sam to CC.
>=20
> Thanks. Will take care later this week.

had some time to look at it / some comments?

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkno9esACgkQuL75KpiFGIzLMwCgunJhTemis5wEZArhq5xSWrnT
QoAAnAlKR+Fqp1aqnCSUW/e/Kdaf+u38
=s2X0
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
