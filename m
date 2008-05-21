Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbYEUM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbYEUM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762174AbYEUM1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:27:15 -0400
Received: from server.drzeus.cx ([85.8.24.28]:56134 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761867AbYEUM1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:27:14 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 08:27:13 EDT
Date: Wed, 21 May 2008 14:21:24 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Kim Hansen" <kimhanse@gmail.com>
Cc: "Alex Dubov" <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: tifm_7xx1: SD card is ignored
Message-ID: <20080521142124.3e43eea4@mjolnir.drzeus.cx>
In-Reply-To: <c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
References: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
	<202777.76958.qm@web36706.mail.mud.yahoo.com>
	<c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-21861-1211372424-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-21861-1211372424-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 May 2008 18:50:54 +0200
"Kim Hansen" <kimhanse@gmail.com> wrote:

> Now it just looks like it sometimes work and other times don't, on
> some kernels it works on 80% inserts and on other it only works on 5%.
> This means that the problem most likely has not been fixed between
> 2.6.24 and 2.6.25, it was just a coincidence that it worked on on and
> not the other the first few times I tested it.

I missed the start of this, but I assume it is just the one card that
exhibits this craziness?

> I have captured some logs now, there is logs of a successful insert
> and remove, and of an unsuccessful.
>=20
> Successful  insert: 16:18:50   remove:  16:20:26
> Unsuccessful insert:  16:21:38  remove:  16:21:47
>=20
> The log can be found at: http://i9.dk/~kim/mmc-log.txt.bz2
>=20
> This is the part from the unsuccessful insert:

*snip*

> sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
> mmc0: req done (CMD5): 0: ffffffff 00000000 00000000 00000000

What can I say, the card thinks it's an SDIO card. :)

The question is why. Might be some shoddy wiring between the card and
the controller that causes some unlucky misinterpretations. Might also
be that the card needs some increased delay to function correctly. Try
adding:

	msleep(500);

to mmc_rescan() in drivers/mmc/core/core.c. Put it right after
mmc_power_up().

Rgds
Pierre

--=_freyr.drzeus.cx-21861-1211372424-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkg0E8gACgkQ7b8eESbyJLiy/QCfRE3k6FC838+BbacIx/OH8QFK
4h4An1Tk5GmKahip1PLVeTkKCxf54SCu
=7e0k
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-21861-1211372424-0001-2--
