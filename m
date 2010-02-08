Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0BHK5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:57:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36929 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0BHK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:57:22 -0500
Date: Mon, 8 Feb 2010 21:57:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaibhav Hiremath <hvaibhav@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-Id: <20100208215715.c78b2a9c.sfr@canb.auug.org.au>
In-Reply-To: <1265621346.2433.27.camel@tubuntu.research.nokia.com>
References: <20100208172521.abb500b4.sfr@canb.auug.org.au>
	<1265621346.2433.27.camel@tubuntu.research.nokia.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_21_57_15_+1100_bL=DquwXhwRRBvGS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_21_57_15_+1100_bL=DquwXhwRRBvGS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

On Mon, 08 Feb 2010 11:29:06 +0200 Tomi Valkeinen <tomi.valkeinen@nokia.com=
> wrote:
>
> > P.S. Tomi, this omap_dss2 commit only has your Acked-by not Signed-off-=
by.
>=20
> Hmm, do you mean there's something wrong with that, or "jfyi"? Aren't I,
> as a subsys maintainer, supposed to ack the patches?

If a patch goes through your tree, you are supposed to add a Signed-off-by
line.  See Documentation/SubmittingPatches section called "Sign your
work".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Feb_2010_21_57_15_+1100_bL=DquwXhwRRBvGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktv7gsACgkQjjKRsyhoI8x1NQCfRYoTrsBeCJ5ys0+sjstkNKz6
CK8AnRXsHPHm3509JVoh1/hhRNVTZsha
=Oiqi
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_21_57_15_+1100_bL=DquwXhwRRBvGS--
