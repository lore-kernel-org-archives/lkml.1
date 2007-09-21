Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbXIUQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbXIUQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXIUQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:55:54 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35394 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXIUQzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:55:53 -0400
Date: Fri, 21 Sep 2007 18:57:05 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: sdhci-devel@list.drzeus.cx, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
Message-ID: <20070921185705.3602fb0e@poseidon.drzeus.cx>
In-Reply-To: <46F3D5A3.1070201@overt.org>
References: <46EC3860.3070600@overt.org>
	<20070920182429.247b28fb@poseidon.drzeus.cx>
	<46F3D5A3.1070201@overt.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-18917-1190393729-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-18917-1190393729-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Sep 2007 07:30:59 -0700
Philip Langdale <philipl@overt.org> wrote:

>=20
> This remains confusing. I went and investigated and the SD disable
> bit is 0x20. The one lspci dump from the IFL90 shows that 0x80 is
> set by default, but setting this on my laptop did not disable the
> SD controller. I will need to collect more information from owners
> to find out what's really going on.
>=20
> Do you want to wait on this before taking this patch?
>=20

Preferably. But if you can't figure it out until it is time to merge
things upstream, then I'll go with what we have right now.

Rgds
Pierre

--=_hera.drzeus.cx-18917-1190393729-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8/fi7b8eESbyJLgRAubhAKCLQSI4legUjlzv45GBauLHgLWb9ACcCO5k
9ZEOidOS+Q7PBK9DE+1XSHk=
=y+VH
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-18917-1190393729-0001-2--
