Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZGWFRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZGWFRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZGWFRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:17:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43243 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZGWFRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:17:52 -0400
Date: Thu, 23 Jul 2009 15:17:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: async_tx tree build failure
Message-Id: <20090723151748.4a7d7281.sfr@canb.auug.org.au>
In-Reply-To: <1248323620.24951.2.camel@dwillia2-linux.ch.intel.com>
References: <20090723120004.fac867eb.sfr@canb.auug.org.au>
	<1248323620.24951.2.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_15_17_48_+1000_jeFBgdckaV_syrW+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_15_17_48_+1000_jeFBgdckaV_syrW+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 22 Jul 2009 21:33:40 -0700 Dan Williams <dan.j.williams@intel.com> =
wrote:
>=20
> Gah, yes that commit was half baked.  I have pushed out an updated tree
> with the following fix:

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jul_2009_15_17_48_+1000_jeFBgdckaV_syrW+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpn8nwACgkQjjKRsyhoI8wehgCeJWviL5xOSHaKTgjxdK0OhqX4
tjcAn1LFKyTFc4VZe3Mx4/DcRUhIjxFt
=UKBp
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_15_17_48_+1000_jeFBgdckaV_syrW+--
