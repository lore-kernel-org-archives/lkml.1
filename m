Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYKBOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYKBOlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 09:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYKBOlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 09:41:04 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:55469 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbYKBOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 09:41:01 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1225546878.4390.3.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hllMFLzFF2bfef+Co3Ru"
Date: Sun, 02 Nov 2008 14:40:47 +0000
Message-Id: <1225636847.2221.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=ZWCJgSG58-_-BMbkNFMA:9 a=aQhpfArIpOkwF2B-K_lMv0qBiD0A:4 a=LY0hPdMaydYA:10 a=Dbv4qdoy1vwL-7DUkQsA:9 a=CCGck8OPCwraqAqCtDXlHzfflxUA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hllMFLzFF2bfef+Co3Ru
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 09:41 -0400, Trond Myklebust wrote:
>=20
>=20
> Have you tested with the TCP RST fix yet? It has been merged into
> mainline, so it should be in the latest 2.6.28-git, but I've attached
> it so you can apply it to your test kernel...

I wasn't aware of it. I'll give it a go.

Thanks,
Ian.
>=20
--=20
Ian Campbell

His designs were strictly honourable, as the phrase is: that is, to rob
a lady of her fortune by way of marriage.
		-- Henry Fielding, "Tom Jones"

--=-hllMFLzFF2bfef+Co3Ru
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkNu+4ACgkQM0+0qS9rzVm0sgCgz5XsiKjvnFSAAtTiwW0M6Jfm
E5IAoJEOjBhaj7FYu3ed710bgwUFxTyv
=/iLL
-----END PGP SIGNATURE-----

--=-hllMFLzFF2bfef+Co3Ru--

