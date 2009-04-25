Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZDYMZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZDYMZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 08:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZDYMZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 08:25:04 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:42225 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZDYMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 08:25:03 -0400
Date: Sat, 25 Apr 2009 14:24:44 +0200
From: Nico Schottelius <nico-nospam@schottelius.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Nico Schottelius <nico-linux-20090330@schottelius.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [Resend] [PATCH] Fix scripts/setlocalversion with git
Message-ID: <20090425122443.GA2554@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-nospam@schottelius.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Nico Schottelius <nico-linux-20090330@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	trivial@kernel.org
References: <20090330122137.GA6918@denkbrett.schottelius.org> <20090407154437.GA31758@ikn.schottelius.org> <alpine.LNX.2.00.0904071755540.5327@wotan.suse.de> <20090407174550.GB13089@uranus.ravnborg.org> <20090417213436.GA16933@ikn.schottelius.org> <20090417215802.GA16568@uranus.ravnborg.org> <20090418091653.GB16933@ikn.schottelius.org> <20090425075019.GB28196@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20090425075019.GB28196@uranus.ravnborg.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc2-next-20090420 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg [Sat, Apr 25, 2009 at 09:50:19AM +0200]:
> On Sat, Apr 18, 2009 at 11:16:53AM +0200, Nico Schottelius wrote:
> > Sam Ravnborg [Fri, Apr 17, 2009 at 11:58:02PM +0200]:
> > - Diff against your tree attached (p2)
>=20
> Applied p2 - had to do so manually.

Thanks! This makes life much easier for testers like me :-)

Enjod the sunny saturday!

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknzAQsACgkQuL75KpiFGIyCMwCgjo8xxATFYje7JPVmaGWJ86r9
vN0An33s4f8qSASj6te4ERddex2IiBPf
=af62
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
