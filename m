Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYKPSpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYKPSpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYKPSjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:39:08 -0500
Received: from pusher.mail.ru ([194.67.23.231]:30748 "EHLO mx48.mail.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbYKPSjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:39:07 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11911] new PCMCIA device instance after resume - orinoco can't download firmware
Date: Sun, 16 Nov 2008 21:38:49 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave" <kilroyd@googlemail.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.L-F.TBGIJB@chimera>
In-Reply-To: <Q7OAnAv0V3D.A.L-F.TBGIJB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3887649.qcidvAYxqE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811162138.50460.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3887649.qcidvAYxqE
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 16 November 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>=20

Still valid in rc5. As indicated by

http://marc.info/?l=3Dlinux-kernel&m=3D122679210409961&w=3D2

pull request was apparently lost.

>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11911
> Subject		: new PCMCIA device instance after resume - orinoco can't downlo=
ad firmware
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> Date		: 2008-10-28 19:19 (20 days old)
> References	: http://marc.info/?l=3Dlinux-wireless&m=3D122522165719760&w=
=3D4
> Handled-By	: Dave <kilroyd@googlemail.com>
> Patch		: http://marc.info/?l=3Dlinux-wireless&m=3D122539058601588&w=3D4
>=20
>=20
>=20



--nextPart3887649.qcidvAYxqE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkgaLoACgkQR6LMutpd94z6dwCfU7T8I7UfeLRvPfLbIMa7pfbp
TWIAoMuE34qJrj8bldq84QZzIQ1i0KLD
=L+1L
-----END PGP SIGNATURE-----

--nextPart3887649.qcidvAYxqE--
