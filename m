Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbXGaWBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbXGaWBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760848AbXGaWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:01:40 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32868 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756336AbXGaWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:01:39 -0400
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
From: Zan Lynx <zlynx@acm.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731150245.5932b763.randy.dunlap@oracle.com>
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F2MZa7p2jUXTTq9ijCPl"
Date: Tue, 31 Jul 2007 16:01:37 -0600
Message-Id: <1185919297.6981.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F2MZa7p2jUXTTq9ijCPl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-31 at 15:02 -0700, Randy Dunlap wrote:
> On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
>=20
> > I was playing with huge pages and libhugetlbfs.  Small programs like
> > "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> > system slowly stops running.  One interesting thing is the "ps" command=
,
> > it gets stuck like this:
>=20
> Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?

D'oh!  I mean 2.6.23-rc1-mm1, the 22 was a typo.  Cut & paste to be
sure:
Linux zephyr 2.6.23-rc1-mm1 #1 SMP PREEMPT Wed Jul 25 17:33:04 MDT 2007
x86_64 AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux

--=20
Zan Lynx <zlynx@acm.org>

--=-F2MZa7p2jUXTTq9ijCPl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGr7FBG8fHaOLTWwgRApisAJ9egVX/t3Il4BJ3/LGttGNlNMQPHQCcDEn4
jeqIDDEsfrYqrmDHpFea898=
=Wr/h
-----END PGP SIGNATURE-----

--=-F2MZa7p2jUXTTq9ijCPl--

