Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZGZXdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZGZXdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZGZXdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:33:38 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:50392 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZGZXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:33:38 -0400
Date: Sun, 26 Jul 2009 20:33:32 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #13643] Touchpad lost synchronization after resume from
	suspend to RAM
Message-ID: <20090726233331.GA4712@vespa.holoscopio.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.JcF.gIObKB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.JcF.gIObKB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2009 at 10:23:34PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13643
> Subject		: Touchpad lost synchronization after resume from suspend to RAM
> Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
> Date		: 2009-06-28 10:42 (29 days old)
> References	: http://lkml.org/lkml/2009/6/23/365
> 		  2.6.30-rc1: touchpad disabled
> 		  http://lkml.org/lkml/2009/6/25/256
> Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Patch		: http://patchwork.kernel.org/patch/34075/
>=20
>=20

I guess my patch did fix it and we had other confirmations as well,
didn't we?

Thanks,
Cascardo.

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkps58sACgkQyTpryRcqtS0RLwCfXK7xLQlGQ3jkwPKevRDsAyip
6uAAn2n8JnsIgRLx/081pvwXsxH5a0EQ
=BZ4S
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
