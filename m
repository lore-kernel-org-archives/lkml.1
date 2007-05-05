Return-Path: <linux-kernel-owner+w=401wt.eu-S1423120AbXEEALG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423120AbXEEALG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423130AbXEEALF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:11:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423120AbXEEALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:11:04 -0400
Message-ID: <463BCB87.2050404@redhat.com>
Date: Fri, 04 May 2007 17:10:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au>
In-Reply-To: <463BC62C.3060605@yahoo.com.au>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE80FF6F95FE0756724D65ED"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE80FF6F95FE0756724D65ED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> I literally have about 4 or 5 new page flags I'd like to add today :) I=

> can't of course, because we have very few spare ones left.

I remember Rik saying that if need be he can (try to?) think of a method
to implement it without a page flag.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCE80FF6F95FE0756724D65ED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGO8uH2ijCOnn/RHQRAmrtAJ48l3JioFC+xab1rmDGu+v4qCBLGwCfYzci
LXUeJBoZ/U2kPmsD6lsgzJ4=
=zZvy
-----END PGP SIGNATURE-----

--------------enigCE80FF6F95FE0756724D65ED--
