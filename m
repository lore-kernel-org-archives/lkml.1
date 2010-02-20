Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0BTI5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:57:10 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:56936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0BTI5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:57:06 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7SuY73oIWyVPk6EOjYN6"
Date: Sat, 20 Feb 2010 09:56:53 +0100
Message-ID: <1266656213.5347.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7SuY73oIWyVPk6EOjYN6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 15:13 +0800, Am=C3=A9rico Wang wrote:

> Does my following untested patch help?

Sorry, no. I'll hook up a screen to the box after I return from the
fresh market.

johannes

--=-7SuY73oIWyVPk6EOjYN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf6PSAAoJEODzc/N7+QmasiYP/jAW8FxKm8MBkTuHXEuFEW+E
KpaZo3IxeLGl5qSLUi+0PZDsQooGXY7WO5csN9cVYqVE/+BiG6c8OxahKClZwoMX
h9j/Dcg+CXsVqkiCpo2698AkES60fc8n/m8O/eL3nHyQ5lAIgy+OxaF0qaBw+73z
pIve24iYvkeAklrjucQMljr5LHjcrQGOjnhCT1l200Q5VUNdHxEcWwnY2aQbsXct
F/tz+LRBij7ORW/ijZs4ULjm6e0sPOLVhIvaJS9vjXVkRVDMTBzV0HcMIH/h3Bbn
rdEJq/FvP+phwkhH4lXC/eqFo22BMZX/9o8ONApFaV4AUqZvVhKS81uuM7XZX35b
j77qT6NE/3QpWEfqnZzgcC3Od734d+fq8fOajzAwETWGEErmNTosXS3KS+Mc25/Q
hHMbNVrmDTxuM1yk8GOodcQdllbpMlq4O9Mxz+a0DHOFteSOmClmxg4Xz9cq/13b
aO8LONjPL1GTlJ2IUnXuUuB4/cU+P6KiTOBIEJRLewhy2saZGx3Xkq4aFgYJJVF1
qDKDdK1d2IjVkZoBH0B28UkEmDHdZ6MSfvm7EUdlHYY8XI+qNg+1yk5yj845Trxw
w1b/7nRjQfGotAa5XfsFqpwQwFWhYp21EDGBl89+z/dDf4aHmOQ17JFkN3KUmkXi
mothzH49ZOCkjDWQRO8Y
=yCeE
-----END PGP SIGNATURE-----

--=-7SuY73oIWyVPk6EOjYN6--

