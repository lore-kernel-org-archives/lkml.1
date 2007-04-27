Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXD0COJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXD0COJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXD0COJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:14:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbXD0COI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:14:08 -0400
Message-ID: <46315C61.30001@redhat.com>
Date: Thu, 26 Apr 2007 19:13:53 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown>
In-Reply-To: <17969.22692.855242.359680@notabene.brown>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCACC46BE3C1F8D5321E7971A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCACC46BE3C1F8D5321E7971A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Neil Brown wrote:
> Does it also specify how to find out what granularity is used by the
> filesystem?  I had a need for this just recently and couldn't see any
> way to extract it.

That's still on the table.  We might end up with an fpathconf() solution.=


--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCACC46BE3C1F8D5321E7971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMVxh2ijCOnn/RHQRAjUVAKCuT+2RasUn5iowZn6BzmtqtcA+WgCcCw5i
q+sxhEkbHLGC5jiHH5yk0z8=
=meVJ
-----END PGP SIGNATURE-----

--------------enigCACC46BE3C1F8D5321E7971A--
