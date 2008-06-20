Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYFTTpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYFTTpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYFTTp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:45:27 -0400
Received: from server.drzeus.cx ([85.8.24.28]:48011 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751205AbYFTTp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:45:26 -0400
Date: Fri, 20 Jun 2008 21:45:16 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       ALSA devel <alsa-devel@alsa-project.org>, mulix@mulix.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] looping S/PDIF data
Message-ID: <20080620214516.28e9d3f3@mjolnir.drzeus.cx>
In-Reply-To: <s5hskv97fqk.wl%tiwai@suse.de>
References: <20080531112606.5884a1c9@mjolnir.drzeus.cx>
	<20080617215504.3203a5ed@mjolnir.drzeus.cx>
	<4858B84B.4030800@keyaccess.nl>
	<s5hej6t91u1.wl%tiwai@suse.de>
	<Pine.LNX.4.61.0806191435270.1798@tm8103-a.perex-int.cz>
	<s5hskv97fqk.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-31735-1213990619-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-31735-1213990619-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jun 2008 14:48:19 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> At Thu, 19 Jun 2008 14:39:05 +0200 (CEST),
> Jaroslav Kysela wrote:
> >=20
> > I don't think that this patch is correct. DMA transfers should be disab=
led=20
> > by:
> >=20
> > outl(what, TRID_REG(trident, T4D_STOP_B));
> > outl(val, TRID_REG(trident, T4D_AINTEN_B));
>=20
> They are already in the trigger callback as long as I saw the code
> quickly.  So the problem should be somewhere else.
>=20
> > lines. Adding &=3D ~SPDIF_EN can disable output from AC97 to S/PDIF as =
well.
>=20
> That's true.
>=20
> Anyway, if you are up now, I'll let you hunt further as you are the
> author of the driver :)
>=20

Are there any specs on this hardware? I could play around a bit myself,
but I can't really find any documentation on the registers.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.

--=_freyr.drzeus.cx-31735-1213990619-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhcCNEACgkQ7b8eESbyJLjU0gCgocuIi2CrpHuOG8QDt+DIo0Pd
uqMAoO8rnZa8wfC9Tyh6O0TqtWCKbAW4
=D7TV
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-31735-1213990619-0001-2--
