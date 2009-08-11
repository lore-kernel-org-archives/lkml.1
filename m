Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZHKOyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZHKOyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZHKOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:54:08 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:39474 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZHKOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:54:07 -0400
Date: Tue, 11 Aug 2009 16:53:56 +0200
From: Nico Schottelius <nico-linux-20090804@schottelius.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nico Schottelius <nico-linux-20090804@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Panic on v2.6.31-rc5-34-ga33a052
Message-ID: <20090811145356.GA10915@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090804@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20090804205309.GA6291@ikn.schottelius.org> <alpine.LRH.2.00.0908111625040.11142@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908111625040.11142@twin.jikos.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn2 (Linux 2.6.30 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jiri Kosina [Tue, Aug 11, 2009 at 04:25:48PM +0200]:
> On Tue, 4 Aug 2009, Nico Schottelius wrote:
>=20
> > Running this kernel on the Lenovo x200 and switching from X to console=
=20
> > kernel panics the system.
>=20
> It is not possible to debug this without you providing the kernel message=
s=20
> that preceeded the panic (you can use digital camera to capture the image=
,=20
> if you can't set up a serial console).

I would like to do that, but the screen is simply black.

I'll give a newer version a try, though I would like to see what the
reason for the panic was, too.

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqBhgMACgkQuL75KpiFGIzsEgCfYwvoVQr6iswsh2iv+DSjp0Pa
7TgAoODKu27cHuW7VoQPwB1gPqT1LNuy
=mZeb
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
