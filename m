Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZHPBFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZHPBFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZHPBFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:05:13 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53181 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZHPBFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:05:12 -0400
Date: Sat, 15 Aug 2009 19:21:07 +0200
From: Nico Schottelius <nico-linux-20090804@schottelius.org>
To: Nico Schottelius <nico-linux-20090804@schottelius.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Panic on v2.6.31-rc5-34-ga33a052
Message-ID: <20090815172107.GA15240@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090804@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20090804205309.GA6291@ikn.schottelius.org> <alpine.LRH.2.00.0908111625040.11142@twin.jikos.cz> <20090811145356.GA10915@ikn.schottelius.org> <20090813062318.GA7293@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20090813062318.GA7293@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn2 (Linux 2.6.31-rc6 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Thu, Aug 13, 2009 at 08:23:18AM +0200]:
> Nico Schottelius [Tue, Aug 11, 2009 at 04:53:56PM +0200]:
> > I'll give a newer version a try, though I would like to see what the
> > reason for the panic was, too.
>=20
> 2.6.31-rc5-00470-g85dfd81 works!
>=20
> Even with suspend _and_ resume ;-)

Same for 2.6.31-rc6.

Seems some commit fixed it.

Greets,

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqG7oMACgkQuL75KpiFGIxyBgCg7D6b3LezNQUXtAHsivNL4ADL
Gg4An3+BS3POy0S+J06pv3NLURpeNF2w
=pKdk
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
