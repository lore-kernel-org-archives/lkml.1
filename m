Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYFTWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYFTWBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYFTWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:01:00 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33298 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753485AbYFTWA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:00:59 -0400
Date: Sat, 21 Jun 2008 00:00:50 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       ALSA devel <alsa-devel@alsa-project.org>, mulix@mulix.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] looping S/PDIF data
Message-ID: <20080621000050.43160d47@mjolnir.drzeus.cx>
In-Reply-To: <485C0A97.7020909@keyaccess.nl>
References: <20080531112606.5884a1c9@mjolnir.drzeus.cx>
	<20080617215504.3203a5ed@mjolnir.drzeus.cx>
	<4858B84B.4030800@keyaccess.nl>
	<s5hej6t91u1.wl%tiwai@suse.de>
	<Pine.LNX.4.61.0806191435270.1798@tm8103-a.perex-int.cz>
	<s5hskv97fqk.wl%tiwai@suse.de>
	<20080620214516.28e9d3f3@mjolnir.drzeus.cx>
	<485C0A97.7020909@keyaccess.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-32721-1213998751-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-32721-1213998751-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jun 2008 21:52:55 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 20-06-08 21:45, Pierre Ossman wrote:
> >=20
> > Are there any specs on this hardware? I could play around a bit myself,
> > but I can't really find any documentation on the registers.
>=20
> At:
>=20
> ftp://ftp.alsa-project.org/pub/manuals/trident/
>=20
> there's a 4D-Wave DX technical reference manual and .doc files which at=20
> first glance look useful.
>=20

Ah, thanks. This is an NX, but hopefully they don't differ that much.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.

--=_freyr.drzeus.cx-32721-1213998751-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhcKJcACgkQ7b8eESbyJLgC0QCgmRF6qEaEbn8S+m7NyoRZEgah
HrEAoLbGmjrt+rw6e1AbX3YQKAlPRxVW
=Q79e
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-32721-1213998751-0001-2--
