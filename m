Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0BBWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:33:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab0BBWdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:33:16 -0500
Date: Wed, 3 Feb 2010 09:33:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: usb tree build failure
Message-Id: <20100203093310.80bc412b.sfr@canb.auug.org.au>
In-Reply-To: <20100202135339.GA13117@kroah.com>
References: <20100202171054.aaf86072.sfr@canb.auug.org.au>
	<20100202135339.GA13117@kroah.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Feb_2010_09_33_10_+1100_BJqfOLCS9L75GdI+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Feb_2010_09_33_10_+1100_BJqfOLCS9L75GdI+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 2 Feb 2010 05:53:39 -0800 Greg KH <greg@kroah.com> wrote:
>
> I have already removed this patch, you are correct, it looks like this
> was only tested on ARM :(
>=20
> sorry for the problem, my tree is now updated.

OK, thanks.  I see there has been some discussion of this on LKML as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Feb_2010_09_33_10_+1100_BJqfOLCS9L75GdI+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoqCYACgkQjjKRsyhoI8zUIwCeNlXI4k/Bmy+tWBo2oof1fVGX
BjEAniICu6ONeFrnU3rh0A4EYdDzr3Ue
=lqaK
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Feb_2010_09_33_10_+1100_BJqfOLCS9L75GdI+--
