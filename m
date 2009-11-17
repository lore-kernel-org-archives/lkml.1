Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZKQXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZKQXtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZKQXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:49:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52179 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZKQXtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:49:46 -0500
Date: Wed, 18 Nov 2009 10:49:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: ext Tony Lindgren <tony@atomide.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-Id: <20091118104936.75206ca1.sfr@canb.auug.org.au>
In-Reply-To: <1258452031.2419.2.camel@tubuntu.research.nokia.com>
References: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
	<1258366001.2384.25.camel@tubuntu.research.nokia.com>
	<20091116183425.GN3684@atomide.com>
	<1258452031.2419.2.camel@tubuntu.research.nokia.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Nov_2009_10_49_36_+1100_MJZQ7b1e8Qcb0nPo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Nov_2009_10_49_36_+1100_MJZQ7b1e8Qcb0nPo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

On Tue, 17 Nov 2009 12:00:31 +0200 Tomi Valkeinen <tomi.valkeinen@nokia.com=
> wrote:
>
> On Mon, 2009-11-16 at 19:34 +0100, ext Tony Lindgren wrote:
> > Tomi, please update your patch by leaving out the now unnecessary
> > TWL4030 and regulator sections. See also the updated version of
> > your patch attached.
>=20
> Thanks, updated. Now I'm able to merge linux-omap/for-next and
> dss/for-next without conflicts.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_Nov_2009_10_49_36_+1100_MJZQ7b1e8Qcb0nPo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksDNpAACgkQjjKRsyhoI8z1TwCeMFccmTDeCwA72F5ZnGJFQN44
adUAnAqHxqw8F7lv963HQ/MESa2qDkzA
=rauR
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Nov_2009_10_49_36_+1100_MJZQ7b1e8Qcb0nPo--
