Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYFTR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYFTR0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFTRZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:25:59 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43932 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753339AbYFTRZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:25:58 -0400
Date: Fri, 20 Jun 2008 19:25:49 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Ram kumar" <ramkumar.research@gmail.com>
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Eric BENARD" <ebenard@free.fr>, "Andrew Victor" <linux@maxim.org.za>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Message-ID: <20080620192549.651d4fa9@mjolnir.drzeus.cx>
In-Reply-To: <6306c640806201005n17aba42ag6f0bc344256a1ad@mail.gmail.com>
References: <483FE9E7.7020707@atmel.com>
	<20080609124623.5b6bda48@mjolnir.drzeus.cx>
	<484E4F61.7010007@atmel.com>
	<20080614182831.0360bd77@mjolnir.drzeus.cx>
	<4858DDC1.6080802@atmel.com>
	<20080620183005.13b53235@mjolnir.drzeus.cx>
	<6306c640806201005n17aba42ag6f0bc344256a1ad@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-30468-1213982253-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-30468-1213982253-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jun 2008 10:05:51 -0700
"Ram kumar" <ramkumar.research@gmail.com> wrote:

> Will it be available on maxim.org.za also.?  Because i have downloaded the
> linux 2.6.24 patches from maxim website.I dont know where the arm patches
> are in the http://kernel.org can you just tell me where the patches are ?
>=20
> What about the 6 series patches ? Will it be available too....?
>=20

This will be in my -next branch, based on mainline linux. For anything
else, you'll have to ask the maintainer of the relevant tree.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.

--=_freyr.drzeus.cx-30468-1213982253-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhb6CIACgkQ7b8eESbyJLhC4wCfUojxY7W3fTcVSuuCn2Tg6sug
jLYAn1/pUwT2CEyQTkA4wZg+JWcaOKu8
=YTNJ
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-30468-1213982253-0001-2--
