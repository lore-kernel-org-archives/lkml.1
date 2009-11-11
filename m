Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbZKKVwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbZKKVwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbZKKVwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:52:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379AbZKKVww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:52:52 -0500
Date: Thu, 12 Nov 2009 08:52:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-Id: <20091112085254.d856c4d0.sfr@canb.auug.org.au>
In-Reply-To: <20091111192058.GI24837@atomide.com>
References: <20091111193013.9a4bca3e.sfr@canb.auug.org.au>
	<20091111191213.GH24837@atomide.com>
	<20091111192058.GI24837@atomide.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_08_52_54_+1100_tex7x9YRlTIlJRd4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_08_52_54_+1100_tex7x9YRlTIlJRd4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, 11 Nov 2009 11:20:59 -0800 Tony Lindgren <tony@atomide.com> wrote:
>
> * Tony Lindgren <tony@atomide.com> [091111 11:12]:
> >=20
> > Oops, sorry. Looks like I accidentally included also drivers/usb/host/e=
hci-omap.c
> > as we were testing it in the linux-omap tree.
> >=20
> > I'll drop the drivers/usb/host/ehci-omap.c part from my queue, it shoul=
d get
> > integrated via Greg's queue. I'll just merge the platform init code.
>=20
> Dropped anything touching drivers/usb from my patch. So no need for Greg
> to do anything, the updated version of the patch below for reference.

OK, thanks.  Just as long as we don't forget the necessary updates when
these are all integrated into Linus' tree.  Some conflicts in linux-next
are not a bad thing for that reason.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_08_52_54_+1100_tex7x9YRlTIlJRd4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7MjYACgkQjjKRsyhoI8x1SQCghVS2QTcViQuyaeFR490RmRZg
osgAnA4rNanl/A7MKUvma2XkKdZ37MJ9
=nGgL
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_08_52_54_+1100_tex7x9YRlTIlJRd4--
