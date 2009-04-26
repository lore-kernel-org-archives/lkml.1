Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZDZUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZDZUQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZDZUQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:16:26 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36796 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZDZUQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:16:25 -0400
Date: Sun, 26 Apr 2009 22:15:54 +0200
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Matthew Garrett <mjg@redhat.com>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
Subject: Re: [Bug #12705] X200: Brightness broken since
	2.6.29-rc4-58-g4c098bc
Message-ID: <20090426201554.GC22487@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Matthew Garrett <mjg@redhat.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.EJE.WrE9JB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <egHshlwQQFE.A.EJE.WrE9JB@chimera>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc2-next-20090420 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Sun, Apr 26, 2009 at 11:46:25AM +0200]:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.

Sure, still broken. For some version it works, for most newer not,
as reported.

Can we stop that nag-service and spent time in fixing it better?

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn0wPoACgkQuL75KpiFGIwRvQCdH9JDhLrjR4p4PNMtr6Tpqglb
6t8An3dwhUUvCGZkp8fgXP7OdwTdFiOt
=7wWO
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
