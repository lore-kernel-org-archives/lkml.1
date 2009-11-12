Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZKLFKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZKLFKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZKLFKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:10:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46718 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZKLFKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:10:30 -0500
Date: Thu, 12 Nov 2009 16:10:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
Message-Id: <20091112161028.427787d9.sfr@canb.auug.org.au>
In-Reply-To: <20091111184208.GC24837@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
	<1257856848.21596.753.camel@localhost>
	<1257929140.20378.51.camel@tubuntu.research.nokia.com>
	<1257932641.20378.77.camel@tubuntu.research.nokia.com>
	<20091111184208.GC24837@atomide.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_16_10_28_+1100_0NjpICVRdDwIVqAx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_16_10_28_+1100_0NjpICVRdDwIVqAx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, 11 Nov 2009 10:42:09 -0800 Tony Lindgren <tony@atomide.com> wrote:
>
> * Tomi Valkeinen <tomi.valkeinen@nokia.com> [091111 01:43]:
> > On Wed, 2009-11-11 at 09:45 +0100, Valkeinen Tomi (Nokia-D/Helsinki)
> > wrote:
> > > On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> > > >=20
> > > > could you please kindly ask Stephen (CCed) to include the DSS2 tree=
 into
> > > > linux-next, because you are going to merge it the next merge window=
, and
> > > > there does not seem to be any blocker for this.
> > > >=20
> > > > Being in linux-next for a while is really important.
> > >=20
> > > Stephen, would this be possible? DSS2 driver is rather big piece of
> > > code, even if it's quite isolated, so it would be nice to have it in
> > > linux-next.
> > >=20
> > > What does it require from me? A git tree, obviously, but what should =
it
> > > be based on?
> >=20
> > Ah, I just realized that DSS2 patches depend on patches from Tony's
> > tree. I guess I should base my tree on top of some Tony's tree that is
> > going to linux-next?
>=20
> Or I can merge them into my for-next if that's OK with everybody. This
> merge cycle is a pain for omap as we've moved all the common headers from
> include/mach to include/plat.

If the DSS2 patches really are dependent on other stuff in the omap tree,
then this is probably the best plan.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_16_10_28_+1100_0NjpICVRdDwIVqAx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7mMQACgkQjjKRsyhoI8x7uACgquvbx/NRweGQEzP8KhWpFrmS
lcAAnippiSX2Zuy7xvJVZtN5HK74i3k+
=11qk
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_16_10_28_+1100_0NjpICVRdDwIVqAx--
