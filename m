Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0BXHcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:32:47 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:47274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0BXHcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:32:46 -0500
Subject: Re: [PATCH] windfarm: init sysfs attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
In-Reply-To: <1266979753.23523.1670.camel@pasglop>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
	 <20100220154049.GM3000@hack>
	 <1266680582.17363.7.camel@jlt3.sipsolutions.net>
	 <1266979753.23523.1670.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1CKbKQgA6A8Bhi3F4m7H"
Date: Wed, 24 Feb 2010 08:32:37 +0100
Message-ID: <1266996757.3903.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1CKbKQgA6A8Bhi3F4m7H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-24 at 13:49 +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2010-02-20 at 16:43 +0100, Johannes Berg wrote:
> > This is required for lockdep.
>=20
> Please CC linuxppc-dev@ozlabs.org or it doesn't get caught by
> patchwork.

Eh, sure, but I think it needs to be part of Eric's series?

> I'll fwd that one myself.

Thanks.

johannes

--=-1CKbKQgA6A8Bhi3F4m7H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLhNYSAAoJEODzc/N7+QmaApsP/2k5Mv2iRFQHUSKhHawNMPP4
iz4JDemUvkiCMdtRtr3YFsueHTEjtpdbPFR3FdJnQii0iLYQxWtUB81z1vQEk5RK
Sd9vxt0vlyQV64h5ewZ28+1jTpcCuG4DdzjeijHtFW6cB0iQOVvfjOYD6eaSeVBH
wSlNcb+c6pimCFQZQAU/4vt6uFKs+MtrH60wqEYQn61DUB7gm/JHuEUNlVKz++4X
AdtxBoLHqjBLntOd/a2FFjuk1Yqxek+qfkEuniyIDpwLeoOrdMjQPFQfuIMArZNq
IA251McaBgIpHJPRNkyxb7h+jkwXbkfNgBLLRNjG0dZkTRLp4t/jo1CVvh3XGBqK
pYybJat4K70nKxV5SdXY4nn+0fho/63jm6XenBnpUL3EyWClObhJTQlmCWwe9vjh
SjsaJ6AqoEIvAj4q17vhvIBVyY05eVyMR3a4DT/PkUyRmByM003Jm9NcLzyB26Mc
D7ODBYmnolMZPHucubWkiMnuOsoOG2rMO/uKh9K4+wpmqU8QuYKtNaF4EhMJl/nn
BbZB460Mx88ilHtFTA8FAHMuxKEHcexrf8Bg7KjcMRCE1eQ7oXg9UopG54/FytqS
DndF1tyBLXbnTe4F3AhKjHSe0wL+zpp18P1VdBPR87g/1dAjfDe5QUdE+sPL4our
SzJ7ffDVbo+RojTAZQCG
=PwrI
-----END PGP SIGNATURE-----

--=-1CKbKQgA6A8Bhi3F4m7H--

