Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbYFJKP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbYFJKP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYFJKPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:15:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56499 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbYFJKPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:15:12 -0400
Date: Tue, 10 Jun 2008 20:15:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       "Hinko Ko??evar" <hinko.kocevar@cetrtapot.si>,
       Mikael Starvik <mikael.starvik@axis.com>,
       <linux-kernel@vger.kernel.org>, dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH 2.6.26-rc5 0/2] cris: compile fixes for 2.6.26-rc5
Message-Id: <20080610201501.2c724456.sfr@canb.auug.org.au>
In-Reply-To: <20080610094937.GC4081@axis.com>
References: <4849213A.4080001@cetrtapot.si>
	<20080606183222.GE2201@cs181133002.pp.htv.fi>
	<20080610094937.GC4081@axis.com>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jun_2008_20_15_01_+1000_cO=4fa4+j.feCnTI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jun_2008_20_15_01_+1000_cO=4fa4+j.feCnTI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jasper,

On Tue, 10 Jun 2008 11:49:37 +0200 Jesper Nilsson <Jesper.Nilsson@axis.com>=
 wrote:
>
> Have I understood correctly that a tree exported for -next can be rebased
> without causing any problems? I've hesitated a bit to create a -next tree
> to avoid problems with later merges.

Yes, rebases are OK (but not encouraged :-)).  The rules are that stuff in
the tree for -next must have been posted somewhere appropriate, reviewed,
and unit tested as much as possible and be reasonably expected to be in
the next merge window.

I also merge trees containing fixes for Linus' current tree.

Also, I accept git trees or quilt series.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jun_2008_20_15_01_+1000_cO=4fa4+j.feCnTI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkhOVCUACgkQTgG2atn1QN/tqACY5Oj79/5BHbcerXM8cmgpZMP1
rQCgjFTOBD8S3xXfpy1nkJA/6uWCvHA=
=bWyq
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jun_2008_20_15_01_+1000_cO=4fa4+j.feCnTI--
