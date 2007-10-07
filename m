Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXJGMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXJGMk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXJGMku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 08:40:50 -0400
Received: from amnesiac.heapspace.net ([195.54.228.42]:3664 "EHLO
	amnesiac.heapspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXJGMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 08:40:49 -0400
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2007 08:40:48 EDT
Date: Sun, 7 Oct 2007 15:17:05 +0300
From: Daniel Stone <daniel@fooishbar.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, arashi@sacredchao.net
Subject: Re: Revert "intel_agp: fix stolen mem range on G33"
Message-ID: <20071007121705.GA6098@fooishbar.org>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	Jiri Slaby <jirislaby@gmail.com>, Kyle McMartin <kyle@mcmartin.ca>,
	airlied@linux.ie, dri-devel@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, arashi@sacredchao.net
References: <4706D4B1.6050101@sacredchao.net> <20071006044221.GA14767@fattire.cabal.ca> <20071006053410.GB14767@fattire.cabal.ca> <20071006054234.GC14767@fattire.cabal.ca> <47076651.8020801@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <47076651.8020801@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 06, 2007 at 12:41:21PM +0200, Jiri Slaby wrote:
> On 10/06/2007 07:42 AM, Kyle McMartin wrote:
> > This reverts commit f443675affe3f16dd428e46f0f7fd3f4d703eeab, which
> > breaks horribly if you aren't running an unreleased xf86-video-intel
> > driver out of git.
>=20
> I guess, this will break my graphics, no?
> http://lkml.org/lkml/2007/9/20/447

You need to upgrade Mesa.

Cheers,
Daniel

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHCM5BUVYB1rKAgJQRAnMzAJwNl2xfOgEs+/yaB4ERmngqexVuYgCcDQ7T
2qNdsqrMW5GWT1mWksfsCcY=
=RrE9
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
