Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZDMS0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZDMS0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZDMS0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:26:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbZDMS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:26:20 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239640067.3237.4.camel@ht.satnam>
References: <1239640067.3237.4.camel@ht.satnam>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-epxeof7e1zA5OxSNwYJg"
Date: Mon, 13 Apr 2009 19:26:03 +0100
Message-Id: <1239647163.18110.150.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] radeon_cp: use request_firmware
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-epxeof7e1zA5OxSNwYJg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Please use <ben@decadent.org.uk> for all mail related to my work on
firmware separation, which has nothing to do with my employment.

On Mon, 2009-04-13 at 21:57 +0530, Jaswinder Singh Rajput wrote:
> Moved datah before datal because datah is required before datal.
>=20
> Firmware blob looks like this...
> 	__be32 datah
> 	__be32 datal
>=20
> Thanks to Ben for help and testing.
[...]

This is out of date as there are now an r600_microcode.h and r600_cp.c.
My latest patch (not posted anywhere yet) is at
<http://womble.decadent.org.uk/tmp/fw-patch/0003-radeon-Use-request_firmwar=
e.patch> (patches 0001-0003 should be applicable in order to drm-2.6/drm-li=
nus).  But I don't have any R600/R700 hardware to test it on.

Ben.


--=-epxeof7e1zA5OxSNwYJg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ44O679ZNCRIGYgcRAuzgAJ49OrAazfISmQSbeui2WTcc5w5gbACdFSYZ
pFoAZiyCujpr/mLqhSzzMKg=
=9y++
-----END PGP SIGNATURE-----

--=-epxeof7e1zA5OxSNwYJg--
