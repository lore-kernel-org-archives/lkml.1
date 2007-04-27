Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXD0XbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXD0XbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXD0XbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:31:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894AbXD0XbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:31:09 -0400
Message-ID: <463287B2.7070100@redhat.com>
Date: Fri, 27 Apr 2007 16:30:58 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com> <46314A08.9000209@redhat.com> <46314AAD.9010300@zytor.com> <46314C3B.3040908@redhat.com> <4632842F.20101@zytor.com>
In-Reply-To: <4632842F.20101@zytor.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDA926211485CBA09924477F0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDA926211485CBA09924477F0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin wrote:
> The main use of atime seems to be to figure out when something can be
> automatically deleted.  Anyone else have other usage scenarios?

It's not atime which cannot be set, it's ctime.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigDA926211485CBA09924477F0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMoey2ijCOnn/RHQRAleRAJ4u70nY0T+HEj0V4xAN6BqKVBX2qwCghXo5
4dZJXQgFwfUlWtfw0eZXvaU=
=r8Zc
-----END PGP SIGNATURE-----

--------------enigDA926211485CBA09924477F0--
