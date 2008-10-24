Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYJXNCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYJXNCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYJXNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:02:11 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:47767 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYJXNCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:02:09 -0400
Date: Fri, 24 Oct 2008 15:01:31 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
Message-ID: <20081024130130.GA5816@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Nigel Cunningham <ncunningham@crca.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810240006.19857.rjw@sisk.pl> <1224817394.6623.12.camel@nigel-laptop> <200810240911.05193.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <200810240911.05193.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.27-rc9-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Fri, Oct 24, 2008 at 09:11:04AM +0200]:
> > Not this time. Going off the other log he posted, it's...
> >=20
> > Chipset Mobile Intel=AE GM45 Express Chipset found
>=20
> This is going to be interesting. :-)
>=20
> Nico, if the system is 64-bit, I'd recommend trying .28-rc1.

Yes, I'm on amd64;

As seen on my other post: xorg does not run on .28-rc1

Nico

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkBxyoACgkQuL75KpiFGIyx8gCg2SO3ynwE0VP7di5X5tpuSMfa
KsQAnRKsfCD4ibSLg06pr+DjIU+8QPhy
=JIEv
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
