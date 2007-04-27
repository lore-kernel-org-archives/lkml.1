Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXD0BFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXD0BFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXD0BFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:05:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbXD0BFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:05:39 -0400
Message-ID: <46314C3B.3040908@redhat.com>
Date: Thu, 26 Apr 2007 18:04:59 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com> <46314A08.9000209@redhat.com> <46314AAD.9010300@zytor.com>
In-Reply-To: <46314AAD.9010300@zytor.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0C366564DBA72A8B2DF638C1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0C366564DBA72A8B2DF638C1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin wrote:
> Primarily to let a backup program restore the full state of the filesys=
tem.

Is this wanted?  Or needed?  I would think there are good reasons why
this hasn't been done so far.  Intrusion detection is one reason I can
think of.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig0C366564DBA72A8B2DF638C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMUw72ijCOnn/RHQRAq3vAJ9Gxd4gVbdPVfZT4eYUQvYqn2f8nwCfZid1
xV/t9YrNlY9+KPzBkzTrEGA=
=1Ynd
-----END PGP SIGNATURE-----

--------------enig0C366564DBA72A8B2DF638C1--
