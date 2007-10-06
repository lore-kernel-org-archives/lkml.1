Return-Path: <linux-kernel-owner+w=401wt.eu-S1764958AbXJFTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764958AbXJFTky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXJFTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:40:46 -0400
Received: from home.keithp.com ([63.227.221.253]:1616 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762576AbXJFTkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:40:45 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 15:40:45 EDT
Subject: Re: Revert "intel_agp: fix stolen mem range on G33"
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Jiri Slaby <jirislaby@gmail.com>,
       Kyle McMartin <kyle@mcmartin.ca>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arashi@sacredchao.net
In-Reply-To: <alpine.LFD.0.999.0710060858420.23684@woody.linux-foundation.org>
References: <4706D4B1.6050101@sacredchao.net>
	 <20071006044221.GA14767@fattire.cabal.ca>
	 <20071006053410.GB14767@fattire.cabal.ca>
	 <20071006054234.GC14767@fattire.cabal.ca> <47076651.8020801@gmail.com>
	 <alpine.LFD.0.999.0710060858420.23684@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TyAZvOfvP497A1imj5Jz"
Date: Sat, 06 Oct 2007 12:29:46 -0700
Message-Id: <1191698986.5444.45.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TyAZvOfvP497A1imj5Jz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-10-06 at 08:59 -0700, Linus Torvalds wrote:

> We do have a rule about "no regressions", so I think we'll have to do the=
=20
> revert, but it would be nice to hear what the consequences for the revert=
=20
> is for the affected hardware and new X.org..

No regressions is more important than making new X.org bits work. I'll
make sure that any future fixes for this are tested against older X
versions before having them sent along.

--=20
keith.packard@intel.com

--=-TyAZvOfvP497A1imj5Jz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHB+IqQp8BWwlsTdMRAjc1AJ9JQR/Y11233N59c8bUXFdmzboTNgCdEO9b
TDvhwDhm+S3CXOW6yEQLxt4=
=Ws9E
-----END PGP SIGNATURE-----

--=-TyAZvOfvP497A1imj5Jz--

