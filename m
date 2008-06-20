Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYFTRD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYFTRD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYFTRDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:03:51 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60991 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbYFTRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:03:50 -0400
Date: Fri, 20 Jun 2008 19:03:40 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Manuel Lauss <mano@roarinelk.homelinux.net>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
 db1200/pb1200 boards.
Message-ID: <20080620190340.5b1b31c9@mjolnir.drzeus.cx>
In-Reply-To: <20080620161239.GA31688@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
	<20080609063702.GC8724@roarinelk.homelinux.net>
	<20080612090206.GB21601@linux-mips.org>
	<20080612101839.GC21601@linux-mips.org>
	<20080612121828.GA24603@roarinelk.homelinux.net>
	<20080612122646.GA9493@linux-mips.org>
	<20080612154248.5c9c5c9d@mjolnir.drzeus.cx>
	<20080612134729.GA20015@linux-mips.org>
	<20080612135810.GA25352@roarinelk.homelinux.net>
	<20080620174607.50ad6874@mjolnir.drzeus.cx>
	<20080620161239.GA31688@roarinelk.homelinux.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-30350-1213980925-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-30350-1213980925-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jun 2008 18:12:39 +0200
Manuel Lauss <mano@roarinelk.homelinux.net> wrote:

> Hello Pierre,
>=20
> On Fri, Jun 20, 2008 at 05:46:07PM +0200, Pierre Ossman wrote:
> >=20
> > This patch does not apply against HEAD. Are you sure there aren't any
> > dependencies on what Ralf has in his tree? If so, perhaps this should
> > be in the MIPS tree.
>=20
> It was broken by commit dab8c6deaf1d654d09c3de8bd4c286d424df255a which we=
nt
> in this week; here's another updated version of [PATCH 2/8].
>=20

The problem is still Ralf's DMA constants fix. Ralf, should I simply
steal that patch from you?

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.

--=_freyr.drzeus.cx-30350-1213980925-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhb4vEACgkQ7b8eESbyJLi8TwCg+dwRurdlaXR1wT39NYU6jMeD
TVkAoIRn1kmEJ3YPnpOr/owxw1qYl65t
=40we
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-30350-1213980925-0001-2--
