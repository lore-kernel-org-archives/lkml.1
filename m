Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYGRWr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYGRWr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGRWrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:47:45 -0400
Received: from server.drzeus.cx ([85.8.24.28]:60604 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752539AbYGRWrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:47:43 -0400
Date: Sat, 19 Jul 2008 00:47:36 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Message-ID: <20080719004736.626ef169@mjolnir.drzeus.cx>
In-Reply-To: <48808EE0.2060603@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23535-1216421260-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23535-1216421260-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2008 21:38:56 +0900
Tejun Heo <htejun@gmail.com> wrote:

>=20
> The offending commit was 83e7d317cef3ee624886f128401a72e414c0a99d
> which implements sg iterator but it forgot to add offset to the
> kmapped address and copy goes out of bounds.  Takashi, this could also
> be the problem you were seeing if you don't have slab debugging turned
> on.
>=20

Oops, sorry. This thing wasn't supposed to go out and mess with anyone
else's tree quite yet. I'll make sure to clean out my -next tree right
away.

> The implemented iterator didn't look too pretty and the usage was
> quite awkward involving a callback and end condition check distributed
> between the callback and the outer user who runs the loop.  For
> copying, end of buffer condition was tested by testing whether the
> callback returned 0 copied bytes for the iteration but AFAIK there's
> no restriction against zero length sg entry in the middle and it will
> terminate the copying prematurely.
>=20
> So, I implemented slightly different version which follows below.
>=20

I just have one objection to your version, and that is that it cannot
be used to nibble away at the sg list. The _next() call jumps an entire
page, whereas you sometimes need to consume that page in two different
sweeps. This could be handled by some external buffer that keeps the
remainder of the page, but the point of these functions was to keep
things simple for the callers.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23535-1216421260-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiBHYoACgkQ7b8eESbyJLjioACgq9/meiFFoM9mYVbZ+dUmHKbR
YkQAniXrU9ByoRAnds3bxb4VqRUg1xaQ
=Hk64
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23535-1216421260-0001-2--
