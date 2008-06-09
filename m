Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYFIN7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYFIN7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYFIN6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:58:51 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58962 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753858AbYFIN6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:58:51 -0400
Date: Mon, 9 Jun 2008 15:58:19 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/7] mmc: at91_mci: add multiwrite switch
Message-ID: <20080609155819.20349623@mjolnir.drzeus.cx>
In-Reply-To: <20080609135356.GD30971@flint.arm.linux.org.uk>
References: <483FE9E7.7020707@atmel.com>
	<483FEE58.5000500@atmel.com>
	<20080601144251.GS5818@flint.arm.linux.org.uk>
	<20080609124249.349995df@mjolnir.drzeus.cx>
	<20080609130831.GC30971@flint.arm.linux.org.uk>
	<20080609154247.06db4c3e@mjolnir.drzeus.cx>
	<20080609135356.GD30971@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-13713-1213019572-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-13713-1213019572-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jun 2008 14:53:57 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Jun 09, 2008 at 03:42:47PM +0200, Pierre Ossman wrote:
> > You're still listed for the primecell driver though. What's the status
> > on that one?
>=20
> It's always reported the number of bytes transferred to/from the card
> (which I think includes the wait for the busy signal to deassert.)
>=20

If only all hardware was like that...

> Probably the best thing is to mark MMCI as orphaned as well - for much
> the same reason.  I've only one remaining MMC card which I use for
> other purposes.  I'm not willing to sacrifice that one for further
> testing, neither am I willing to buy another card to just be used for
> testing purposes.

Fair enough. Could you send a patch, preferably with some relevant
list(s) cc:d in case someone else wants to take over the work?

Rgds
Pierre


--=_freyr.drzeus.cx-13713-1213019572-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhNNv8ACgkQ7b8eESbyJLiKUACg2Udqerz5q6nfKFgquWfVu9NR
GKEAoJNNJNJNxZckIhotDuzPACaeaLel
=cXzW
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-13713-1213019572-0001-2--
