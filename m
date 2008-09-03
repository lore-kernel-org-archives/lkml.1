Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYICHzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYICHzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYICHzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:55:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58134 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYICHzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:55:01 -0400
Date: Wed, 3 Sep 2008 17:54:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: remove unused variable canon_change
Message-Id: <20080903175444.954d9651.sfr@canb.auug.org.au>
In-Reply-To: <20080902233738.a5509cad.akpm@linux-foundation.org>
References: <1220390841.2137.10.camel@brick>
	<20080902233738.a5509cad.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Sep_2008_17_54_44_+1000_QTeVxMThIBEbiU=3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Sep_2008_17_54_44_+1000_QTeVxMThIBEbiU=3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 2 Sep 2008 23:37:38 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Tue, 02 Sep 2008 14:27:21 -0700 Harvey Harrison <harvey.harrison@gmail=
.com> wrote:
>=20
> I cannot find the patch which added the canon_change stuff on a mailing
> list.  If I could, I'd reply to that.

Hmm.

> It goes oops.  config is at http://userweb.kernel.org/~akpm/config-vmm.txt

This is fixed (I haven't tested, but the patch looks better) in linux-next
today with a revised patch from Alan Cox.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Sep_2008_17_54_44_+1000_QTeVxMThIBEbiU=3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki+QsQACgkQjjKRsyhoI8yQugCeJNVUXSKV42GSZydo540uwBMR
8gwAoLavQlkQWxEnv72N3J0jiTLa8dFW
=TVpe
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Sep_2008_17_54_44_+1000_QTeVxMThIBEbiU=3--
