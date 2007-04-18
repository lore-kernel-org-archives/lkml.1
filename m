Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbXDREam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbXDREam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXDREam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:30:42 -0400
Received: from iucha.net ([209.98.146.184]:56934 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXDREal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:30:41 -0400
Date: Tue, 17 Apr 2007 23:30:40 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418043040.GD24044@iucha.net>
References: <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp> <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <20070417211350.ebba1493.akpm@linux-foundation.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 09:13:50PM -0700, Andrew Morton wrote:
> On Tue, 17 Apr 2007 23:07:30 -0500 florin@iucha.net (Florin Iucha) wrote:
> > > > The process traces are at:
> > > >=20
> > > >    http://iucha.net/nfs/21-rc7-nfs1/gnome-session
> > > >    http://iucha.net/nfs/21-rc7-nfs1/big-copy
>=20
> please, do `echo t > /proc/sysrq-trigger' first, send us the result.

Already did.  Traces from vanilla kernel at
   http://iucha.net/nfs/21-rc7/big-copy

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJZ7vND0rFCN2b1sRAmIHAJ0UukdbxlUb1z3yozuaI05ZRq9ExACaAgup
v6q7O4f73Ue6k1mK5eoudyo=
=F64Z
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
