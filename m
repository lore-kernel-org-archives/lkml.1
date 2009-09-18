Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZIRQHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZIRQHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZIRQHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:07:48 -0400
Received: from k66.ru ([87.224.128.21]:64094 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZIRQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:07:47 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2009 12:07:47 EDT
Date: Fri, 18 Sep 2009 21:37:44 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Peter Volkov <pva@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 regression: system hang after pptp connection
 established
Message-ID: <20090918153744.GJ28743@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CNfT9TXqV7nd4cfk"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909180716080.4950@localhost.localdomain>
 <1253217553.3271.77.camel@tablet>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2009 at 11:59:13PM +0400, Peter Volkov wrote:
> Is this problem known?=20
Yes, it's described at http://bugzilla.kernel.org/show_bug.cgi?id=3D14179
since Tuesday.

On Fri, Sep 18, 2009 at 07:16:39AM -0700, Linus Torvalds wrote:
> > The patch fixes the problem here. Thank you very much.
> Hey, thank _you_ for the sysrq output, that made it quite debuggable.
> Committed as 202c4675c, and I cc'd stable.
Thanks for the fix, but should I send bugreports directly here next time
instead of filing a bug in bugzilla.kernel.org and waiting for response
that will never come?

--=20
WBR, wRAR (ALT Linux Team)

--CNfT9TXqV7nd4cfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJKs6lIAAoJEOih81koZvPBjnQH/28KZt95WeWssprBar93nmAi
VlMS5Td0d9p/ftR9Hm2ivyTOHFQ9zaEUnCBpDmoN6kg266rajXc0s025AoEW2GBP
QZEYDb9UZRyIJ2n+ycyrVkysetvHkaPlc2h0LtVGQIuRWNnYkHtpd0IRRTbBwLzl
/UYey9a3J5UnvvHXcI3ExdqE4yzbSnqBCNduBbR/GpZ3YDWqx0uf3SgUtztamTg4
CU12Khu3FR0y47TrwWywbBVfz2I3Eqobj//azPPwD+LR+sYuIAq5SP7b2S6lveq0
hBxbZDeEJK6i62Yn3aWI78bl/tZOF0/Cbhm12mws0tSuoJIxJPMzJMnSCYwYswc=
=TSiO
-----END PGP SIGNATURE-----

--CNfT9TXqV7nd4cfk--
