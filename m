Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXCOTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXCOTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXCOTMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:12:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbXCOTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:12:31 -0400
Message-ID: <45F99A8B.4050003@redhat.com>
Date: Thu, 15 Mar 2007 12:12:11 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pierre.Peiffer@bull.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: Re: [PATCH 2.6.21-rc3-mm2 4/4] sys_futex64 : allows 64bit futexes
References: <20070313095203.154246923@bull.net>	<20070313095549.813330645@bull.net> <20070315110752.f1df4509.akpm@linux-foundation.org>
In-Reply-To: <20070315110752.f1df4509.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB97AC00A631EBB0E89538564"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB97AC00A631EBB0E89538564
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Why do we want 64-bit futexes?

I sent this to you already on 1/12/2007:

http://udrepper.livejournal.com/13123.html

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigB97AC00A631EBB0E89538564
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF+ZqL2ijCOnn/RHQRAuARAKCsI9Wm4n7MYQv7TQzzQOJRg2oRYACeNvC9
EgMkfOxe1RRVlfOvvRqt+pM=
=7EKG
-----END PGP SIGNATURE-----

--------------enigB97AC00A631EBB0E89538564--
