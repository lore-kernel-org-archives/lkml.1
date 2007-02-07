Return-Path: <linux-kernel-owner+w=401wt.eu-S1161415AbXBGSAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161415AbXBGSAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161414AbXBGSAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:00:16 -0500
Received: from cpc2-heck4-0-0-cust581.hudd.cable.ntl.com ([81.105.122.70]:56539
	"EHLO mail.kyllikki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161418AbXBGSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:00:14 -0500
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 13:00:14 EST
Date: Wed, 7 Feb 2007 17:38:42 +0000
From: Vincent Sanders <vince@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: SM501 core driver
Message-ID: <20070207173842.GA19261@kyllikki.org>
References: <20070206192628.GA13644@fluff.org.uk> <20070206210930.fc814bf6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20070206210930.fc814bf6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2007 at 09:09:30PM -0800, Andrew Morton wrote:
> On Tue, 6 Feb 2007 19:26:28 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
>=20
> > This patch is an update patch, ready for merging
> > for the Silicon Motion SM501 multi-function device
> > core.
> >=20
> > This driver handles the core function of the chip,
> > including the clock, power control and allocation
> > of resources for drivers. It also exports a series
> > of platform devices for the function drivers to
> > attach to.
> >=20
> > This patch supports both platform and PCI bus
> > attached devices.
> >=20
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>=20
> Can we get Vincent's signoff here?
>=20

Signed-off-by: Vincent Sanders <vince@arm.linux.org.uk>

hows that ;-)

--=20
Regards Vincent


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFyg6iiUwwPOvjHvURAhksAJwIWbx5p9khTlYVKfthdPd/WRHcsACfQzLb
OxNxhM8JlIdjqqyaCSgfgWQ=
=ps2h
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
