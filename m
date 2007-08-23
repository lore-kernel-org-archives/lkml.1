Return-Path: <linux-kernel-owner+w=401wt.eu-S1765011AbXHWRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765011AbXHWRgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbXHWRgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:36:41 -0400
Received: from iucha.net ([209.98.146.184]:43669 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXHWRgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:36:40 -0400
Date: Thu, 23 Aug 2007 12:36:37 -0500
From: Florin Iucha <florin@iucha.net>
To: Bret Towe <magnade@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: NFS woes again Was: [linux-usb-devel] USB-related oops in
	sysfs with linux v2.6.23-rc3-50-g28e8351
Message-ID: <20070823173637.GS10422@iucha.net>
References: <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net> <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net> <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz> <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net> <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8HhMLSHvAouSipEr"
Content-Disposition: inline
In-Reply-To: <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--8HhMLSHvAouSipEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2007 at 10:14:38AM -0700, Bret Towe wrote:
> this sounds alot like the post i did yesterday titled 'nfs4 hang regressi=
on'
> i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6

Yes, it certainly does -- all the symptoms match!

I'm not [alone in] seeing dead keyboards!

Now, if only somebody could clarify to me the connection between
the bad NFS4 shooting the keyboard but not the mouse, that would
be wonderful.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--8HhMLSHvAouSipEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGzcWlND0rFCN2b1sRAi/kAKCZBWEIvNu/VVCGeo5dwoTNBByAPACeIL3B
qyOxlXpjUbH/R/QmvOgoZgw=
=kzAK
-----END PGP SIGNATURE-----

--8HhMLSHvAouSipEr--
