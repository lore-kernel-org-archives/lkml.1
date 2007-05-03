Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXECLi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXECLi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXECLi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:38:57 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2522 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbXECLi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:38:56 -0400
Date: Thu, 3 May 2007 13:38:22 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
Message-ID: <20070503113822.GA27404@gateway.home>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2007 at 03:04:44PM +0100, Hugh Dickins wrote:
> On Tue, 1 May 2007, Phillip Susi wrote:
> > I seem to remember seeing some patches go by at some point that allowed=
 one of
> > the rom type embeded system filesystems to directly execute binaries ou=
t of
> > the original rom memory rather than copying them to ram first, then exe=
cuting
> > from there.  I was wondering if rootfs or tmpfs support such execute in=
 place
> > today, or if binaries executed from there have their code segments dupl=
icated
> > in ram?
>=20
> Only ext2 supports it today: see Documentation/filesystems/xip.txt

IIRC JFFS2 also supports XIP.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGOcmu/PlVHJtIto0RAsjMAJ4l0TWxX8Bgd1tUU2AQt/1pJCJYkgCfWKQU
JiftOAQKR9gB53BYS/xWXeM=
=iZUy
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
