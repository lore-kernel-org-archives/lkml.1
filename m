Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZKSHFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZKSHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZKSHFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:05:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59980 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZKSHFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:05:15 -0500
Date: Thu, 19 Nov 2009 18:05:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: khali@linux-fr.org, bhutchings@solarflare.com, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mika.kuoppala@nokia.com, linux-i2c@vger.kernel.org
Subject: Re: Shared i2c adapter locking
Message-Id: <20091119180508.0d5bffdc.sfr@canb.auug.org.au>
In-Reply-To: <20091118.225332.18917545.davem@davemloft.net>
References: <20091117193313.b750804e.sfr@canb.auug.org.au>
	<20091117103554.03971b2f@hyperion.delvare>
	<20091118075917.9ac0248c.sfr@canb.auug.org.au>
	<20091118.225332.18917545.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Nov_2009_18_05_08_+1100_yST2g=Iw.zrcc3HG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Nov_2009_18_05_08_+1100_yST2g=Iw.zrcc3HG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 18 Nov 2009 22:53:32 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 18 Nov 2009 07:59:17 +1100
>=20
> >> If you did and something is still not clear, please let me know. My
> >> understanding is that the action token is in David's hands now.
> >=20
> > OK, I will await developments :-)
>=20
> I just took care of all of this.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Nov_2009_18_05_08_+1100_yST2g=Iw.zrcc3HG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAksE7iQACgkQjjKRsyhoI8zdtACguHmvYrF55M2wuUU9uxdJpUnx
WR4AmKrXey/JFiDU+4WMsbKvqG928Wo=
=BjGH
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Nov_2009_18_05_08_+1100_yST2g=Iw.zrcc3HG--
