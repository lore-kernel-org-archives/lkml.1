Return-Path: <linux-kernel-owner+w=401wt.eu-S935524AbYEIGKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524AbYEIGKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934302AbYEIGKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:10:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54643 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764925AbYEIGKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:10:20 -0400
Date: Fri, 9 May 2008 16:10:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-Id: <20080509161012.a8346a55.sfr@canb.auug.org.au>
In-Reply-To: <20080509041802.GA16414@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au>
	<20080508042753.GA6876@kroah.com>
	<20080508062715.GE14951@cs181133002.pp.htv.fi>
	<20080508220443.GE7705@kroah.com>
	<20080509111608.09574cf0.sfr@canb.auug.org.au>
	<20080509034427.GA14584@kroah.com>
	<20080509041802.GA16414@kroah.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_May_2008_16_10_12_+1000_TLKh+t1fgZJpU8JC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_May_2008_16_10_12_+1000_TLKh+t1fgZJpU8JC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 8 May 2008 21:18:02 -0700 Greg KH <greg@kroah.com> wrote:
>
> Now done, the sequence is:
> 	driver-core.current
> 	usb.current
> 	driver-core
> 	usb
> 	ldp.next
>=20
> I left ldp.next as that is really only for the -next tree.
>=20
> If you have any problems with this, please let me know.

That looks OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_May_2008_16_10_12_+1000_TLKh+t1fgZJpU8JC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFII+rHTgG2atn1QN8RAl+gAJ9YCVvIh+VZK+/dbSk4IYWUZAL6dgCeMPWJ
yFp8fgyDxjBc0aGu8hZSyZY=
=NSTf
-----END PGP SIGNATURE-----

--Signature=_Fri__9_May_2008_16_10_12_+1000_TLKh+t1fgZJpU8JC--
