Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbXISLUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbXISLUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbXISLUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:20:37 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:60833 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbXISLUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:20:36 -0400
Date: Wed, 19 Sep 2007 07:20:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Combine instrumentation menus in kernel/Kconfig.instrumentation
Message-ID: <20070919112033.GF15500@Krystal>
References: <20070918211259.GA14927@Krystal> <14754.1190151939@turing-police.cc.vt.edu> <20070919010627.GA24174@Krystal> <3956.1190181478@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_Krystal-17485-1190200834-0001-2"
Content-Disposition: inline
In-Reply-To: <3956.1190181478@turing-police.cc.vt.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:19:23 up 51 days, 11:38,  3 users,  load average: 1.55, 1.46, 1.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_Krystal-17485-1190200834-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Tue, 18 Sep 2007 21:06:28 EDT, Mathieu Desnoyers said:
> =20
> > * Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > > OK, I'll bite - given the mention of 'debugging' there, do we want to=
 go for
> > > broke and *also* suck in the 'Kernel Hacking' menu as well?
> >=20
> > Instrumentation primarity aims at debugging user-space applications by
> > giving the ability to extract information across execution layers, hence
> > being a feature useful to users, not only kernel hackers.
>=20
> Ahh.. Where I come from, "Instrumentation" includes *all* the code that d=
oesn't
> actually *do* the work, but exists solely so you can tell what the code is
> doing - so almost everything on the i386/x86_64 "Kernel Hacking" menu cou=
nts
> as "instrumentation" in my book.
>=20
> Now if we're talking about the features provided by one specific *instanc=
e*
> of instrumentation code, I can buy that too - but I think that help text
> needs to be clear on what is included under "debugging"
>=20
> (I'd settle for "If you're trying to debug the kernel itself, go see the
> Kernel Hacking menu" or similar.. ;)
>=20

Ok, let's add that.

> > to many, not only kernel developers. Please have a look at the
> > papers (especially the OLS2007 paper) linked on http://ltt.polymtl.ca a=
s a
> > starting point if you are intereted in the question.
>=20
> Ahh, LTT. *that* I recognize.  Yeah, I count that as *one flavor* of
> instrumentation. :)
>=20

Systemtap, kprobes and oprofile would also fall into the same category.

Mathieu


--=20
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

--=_Krystal-17485-1190200834-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8QYBPyWo/juummgRArPQAJ4+BQht8ZNcP3gVYKcluk4tzlFRSQCfZaIo
j2474zaDED2YDHiO/FvOT5U=
=hMdS
-----END PGP SIGNATURE-----

--=_Krystal-17485-1190200834-0001-2--
