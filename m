Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYBHWKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYBHWKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbYBHWHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:07:50 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:39078 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbYBHWHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:07:47 -0500
Date: Sat, 9 Feb 2008 00:06:29 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben@fluff.org>
Cc: Matt Porter <mporter@kernel.crashing.org>, Vitaly Luban <vitaly@luban.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Message-ID: <20080209000629.54dafa2c@poseidon.drzeus.cx>
In-Reply-To: <20071203143926.GC7855@fluff.org.uk>
References: <47511ADA.20506@luban.org>
	<20071201215010.2fa3b334@poseidon.drzeus.cx>
	<20071203142207.GA28101@gate.crashing.org>
	<20071203143926.GC7855@fluff.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-12654-1202508465-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-12654-1202508465-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Dec 2007 14:39:26 +0000
Ben Dooks <ben@fluff.org> wrote:

> On Mon, Dec 03, 2007 at 08:22:07AM -0600, Matt Porter wrote:
> >=20
> > What's the status of Ben's separation patches? I haven't seen a posting=
 of those
> > versus a recent kernel. I've got some SDHCI driver glue for the non-pci=
 Arasan core
> > running in an older kernel tree with those patches. It's just waiting f=
or the separation
> > patches to hit the mmc or mainline tree.
>=20
> I need to go back and try and sort out the last of Pierre's last
> comments, and update to the latest kernel version. I was waiting
> for 2.6.24-rc4 to re-start the effort to try and ensure there are
> fewer changes due to fixes.
>=20

Any progress on this little project?

Rgds
Pierre

--=_hera.drzeus.cx-12654-1202508465-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkes4HUACgkQ7b8eESbyJLidaACfWzd2rn8P5izNP7htOLqlIZ/5
/PAAoOdVSGE/wZYCJ385C2Y1GpMaWVcZ
=3ckW
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-12654-1202508465-0001-2--
