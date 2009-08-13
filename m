Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZHMHZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZHMHZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZHMHZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:25:13 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:48403 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZHMHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:25:12 -0400
Date: Thu, 13 Aug 2009 08:23:18 +0200
From: Nico Schottelius <nico-linux-20090804@schottelius.org>
To: Nico Schottelius <nico-linux-20090804@schottelius.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Panic on v2.6.31-rc5-34-ga33a052
Message-ID: <20090813062318.GA7293@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090804@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20090804205309.GA6291@ikn.schottelius.org> <alpine.LRH.2.00.0908111625040.11142@twin.jikos.cz> <20090811145356.GA10915@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20090811145356.GA10915@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn2 (Linux 2.6.31-rc5-00470-g85dfd81 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Tue, Aug 11, 2009 at 04:53:56PM +0200]:
> I'll give a newer version a try, though I would like to see what the
> reason for the panic was, too.

2.6.31-rc5-00470-g85dfd81 works!

Even with suspend _and_ resume ;-)

Greets,

Nico

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqDsVYACgkQuL75KpiFGIzkvgCfQeBGbiw3E+g0ptI5ryrFnAYo
64kAnA9WQtPrd6MSM9A+pmMiTIHd8BkJ
=5Ge5
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
