Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0BXECL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:02:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0BXECI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:02:08 -0500
Date: Wed, 24 Feb 2010 15:01:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of usb series failed
Message-Id: <20100224150156.d7449bc7.sfr@canb.auug.org.au>
In-Reply-To: <20100224021624.GB14159@kroah.com>
References: <20100218105500.898ece5e.sfr@canb.auug.org.au>
	<20100218002144.GA17850@kroah.com>
	<20100218132221.b15d151f.sfr@canb.auug.org.au>
	<20100219175218.10025a7a.sfr@canb.auug.org.au>
	<20100219155343.GA3946@kroah.com>
	<20100220120207.1d765147.sfr@canb.auug.org.au>
	<20100224021624.GB14159@kroah.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Feb_2010_15_01_56_+1100_YGgliJaOgrn0DgS9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Feb_2010_15_01_56_+1100_YGgliJaOgrn0DgS9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 23 Feb 2010 18:16:24 -0800 Greg KH <greg@kroah.com> wrote:
>
> Yes, that seems to be the problem here.
>=20
> I have been doing the BASE tag as a -rc level tag (or rc-gitX tag), can
> I use a SHA1 of Linus's tree to base this against instead?  Would that
> work ok with your scripts?

What ever "git describe" gives you is OK as a BASE.  A SHA1 will work as
well, as does a ...-gitx name.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Feb_2010_15_01_56_+1100_YGgliJaOgrn0DgS9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuEpLQACgkQjjKRsyhoI8x7dACbBgafKoOE3zeu+o1D/qGR4kt/
OpoAni0IjqpAOvglPJFyQB+8F/vtIrsT
=rUms
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Feb_2010_15_01_56_+1100_YGgliJaOgrn0DgS9--
