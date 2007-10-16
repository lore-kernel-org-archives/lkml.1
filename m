Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXJPPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXJPPMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbXJPPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:12:15 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:42005 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932412AbXJPPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:12:15 -0400
Date: Tue, 16 Oct 2007 17:12:07 +0200
From: Kristof Provost <Kristof@provost-engineering.be>
To: Jan-Simon M?ller <dl9pf@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>
Subject: Re: [BUG] memory leak in dm
Message-ID: <20071016151207.GA4452@luggage>
References: <20071016113800.GA4631@luggage> <20071016114458.GD5263@kernel.dk> <200710161523.47111.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <200710161523.47111.dl9pf@gmx.de>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Scanned: 2.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2007-10-16 15:23:46 (+0200), Jan-Simon M?ller <dl9pf@gmx.de> wrote:
> Am Dienstag 16 Oktober 2007 13:44:58 schrieb Jens Axboe:
> > Please try with this patch from Neil.
> Tried the patch. Now its usable - as far as i can say. Compiled a fresh k=
ernel=20
> to "stress" the system (make -j3).
> Without the patch the system had freezed after some minutes during compil=
e.
Same here. As far as I can tell it's fixed.

Thanks,
Kristof=20

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHFNTGUEZ9DhGwDugRAkx/AJ4wwCDTQo8KxSFWXONeH6KhZAm8HQCcCbRC
f2EcUOEWbTscqzMfcX4V/P8=
=SkcJ
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
