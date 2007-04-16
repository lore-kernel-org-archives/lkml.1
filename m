Return-Path: <linux-kernel-owner+w=401wt.eu-S1030959AbXDPUzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030959AbXDPUzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030962AbXDPUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:55:53 -0400
Received: from mail.suse.de ([195.135.220.2]:39068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030939AbXDPUzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:55:51 -0400
Date: Mon, 16 Apr 2007 13:56:12 -0700
From: John Johansen <jjohansen@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070416205612.GA4030@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090849.465428000@suse.de> <p733b35903l.fsf@bingen.suse.de> <200704151621.52906.agruen@suse.de> <20070416062708.GA14641@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20070416062708.GA14641@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2007 at 08:27:08AM +0200, Andi Kleen wrote:
> > It's nice to check for consistency though, so we're adding that. Profil=
e=20
> > loading is a trusted operation, at least so far, and so security wise w=
e=20
> > don't actually have to care --- if loading an invalid profile can bring=
 down=20
> > the system, then that's no worse than an arbitrary module that crashes =
the=20
> > machine. Not sure if there will ever be user loadable profiles; at leas=
t at=20
> > that point we had to care.
>=20
> A security system that allows to crash the kernel is a little weird=20
> though. It would be better to check. Not that a recursion check
> is particularly expensive.
>=20
Indeed.  It will be fixed in the next rev.

thanks
john


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFGI+Lsi/GH5xuqKCcRAo/WAJ41H0KTy9tYDUzYmtOp0fNp+4oZ/gCcDB4u
QB/zbUDpIInmG+L73hJwof4=
=mWyw
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
