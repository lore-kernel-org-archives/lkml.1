Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbXFGMEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbXFGMEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXFGMEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:04:32 -0400
Received: from iucha.net ([209.98.146.184]:52621 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbXFGMEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:04:31 -0400
Date: Thu, 7 Jun 2007 07:04:30 -0500
To: Robert Hancock <hancockr@shaw.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: spurious completions during NCQ?
Message-ID: <20070607120430.GB30661@iucha.net>
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <4666C477.1070603@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
In-Reply-To: <4666C477.1070603@shaw.ca>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 06, 2007 at 08:28:07AM -0600, Robert Hancock wrote:
> >This is on a Thinkpad T60 with 2 GB RAM, running Ubuntu 7.04 (kernel
> >2.6.20-16-generic).  No proprietary drivers (ok, maybe the Intel
> >Wi-Fi - but that should not count).
> >
> >The laptop came with Windows but I blew that away - did I mess some
> >thing up regarding HPA and its ilk?
>=20
> It means the drive reported command tags were completed that were not=20
> outstanding. What kind of drive is this?

[   29.033142] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_sector=
s =3D 156
301488
[   29.033146] ata1.00: ATA-7: HITACHI HTS541680J9SA00, SB2IC7EP, max UDMA/=
100
[   29.033149] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   29.034230] ata1.00: ata_hpa_resize 1: sectors =3D 156301488, hpa_sector=
s =3D 156
301488

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZ/ROND0rFCN2b1sRAos+AKCenNAmIBxlwPaqfjTZLAhYwtT+1ACeLsm1
TbyGsR0JY0M9BaS/CXducmA=
=OcR1
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
