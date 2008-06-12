Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYFLNyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYFLNyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbYFLNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:54:28 -0400
Received: from server.drzeus.cx ([85.8.24.28]:35531 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751755AbYFLNy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:54:27 -0400
Date: Thu, 12 Jun 2008 15:53:47 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-mips@linux-mips.org,
       sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
 db1200/pb1200 boards.
Message-ID: <20080612155347.7bd9e18b@mjolnir.drzeus.cx>
In-Reply-To: <20080612134729.GA20015@linux-mips.org>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
	<20080609063702.GC8724@roarinelk.homelinux.net>
	<20080612090206.GB21601@linux-mips.org>
	<20080612101839.GC21601@linux-mips.org>
	<20080612121828.GA24603@roarinelk.homelinux.net>
	<20080612122646.GA9493@linux-mips.org>
	<20080612154248.5c9c5c9d@mjolnir.drzeus.cx>
	<20080612134729.GA20015@linux-mips.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-19290-1213278469-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-19290-1213278469-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jun 2008 14:47:30 +0100
Ralf Baechle <ralf@linux-mips.org> wrote:

>=20
> If we're only talking about a build, there should be no dependencies
> between the Alchemy and the MMC parts of the series.  The Alchemy part
> sorts the device registration and that's a separate construction site
> from the rest.  Of course with only one applied things won't work
> terribly well but that would only be temporarily.
>=20

I suppose that should be sufficient. I'll queue up the patches here.

--=_freyr.drzeus.cx-19290-1213278469-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhRKnEACgkQ7b8eESbyJLgAnwCgjGrblboOg3yCWsqQxU36tg/E
3DwAn3wOEunhdvCSgqLXQ+uSFEUNV06l
=vsnF
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-19290-1213278469-0001-2--
