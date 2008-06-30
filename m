Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYF3RLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYF3RLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYF3RLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:11:44 -0400
Received: from server.drzeus.cx ([85.8.24.28]:56354 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753241AbYF3RLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:11:43 -0400
Date: Mon, 30 Jun 2008 19:11:33 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       ALSA devel <alsa-devel@alsa-project.org>, mulix@mulix.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] looping S/PDIF data
Message-ID: <20080630191133.7f7c349d@mjolnir.drzeus.cx>
In-Reply-To: <485CF0AE.3020204@keyaccess.nl>
References: <20080531112606.5884a1c9@mjolnir.drzeus.cx>
	<20080617215504.3203a5ed@mjolnir.drzeus.cx>
	<4858B84B.4030800@keyaccess.nl>
	<s5hej6t91u1.wl%tiwai@suse.de>
	<Pine.LNX.4.61.0806191435270.1798@tm8103-a.perex-int.cz>
	<s5hskv97fqk.wl%tiwai@suse.de>
	<20080620214516.28e9d3f3@mjolnir.drzeus.cx>
	<485C0A97.7020909@keyaccess.nl>
	<20080621000050.43160d47@mjolnir.drzeus.cx>
	<485C2DF7.7080408@keyaccess.nl>
	<20080621010910.018f880d@mjolnir.drzeus.cx>
	<485CF0AE.3020204@keyaccess.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-9717-1214845266-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-9717-1214845266-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jun 2008 14:14:38 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 21-06-08 01:09, Pierre Ossman wrote:
>=20
> > trident: pause s/pdif output
> >=20
> > Stop the S/PDIF DMA engine and output when the device is told to pause.
> > It will keep on looping the current buffer contents if this isn't done.
> >=20
> > Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>=20
> Verified to fix the reported pause problem on a 4DWaveNX (and indeed to=20
> not affect a 4DWaveDX). The Trident SPDIF doesn't seem capable of 44100=20
> which for me means it's not all that useful but you no doubt know=20
> yourself that/if it is for you...
>=20
> Tested-by: Rene Herman <rene.herman@gmail.com>


Sooo.... ack? nak? limbo?

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-9717-1214845266-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhpE8sACgkQ7b8eESbyJLg17QCfXfHsi/d+P6UenxdmiLyAmBGw
OVEAmgLJq9jIFYpx+N/nXnk1iUbP7RUR
=GHVX
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-9717-1214845266-0001-2--
