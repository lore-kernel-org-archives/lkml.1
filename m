Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXD0Rqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXD0Rqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXD0Rqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:46:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbXD0Rqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:46:33 -0400
Message-ID: <463236EA.3030806@redhat.com>
Date: Fri, 27 Apr 2007 10:46:18 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@openvz.org
Subject: Re: [PATCH] v4: merged utimensat implementation
References: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com> <20070427173247.GA5986@martell.zuzino.mipt.ru>
In-Reply-To: <20070427173247.GA5986@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B996CF09F0CC09F0F988B88"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B996CF09F0CC09F0F988B88
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Alexey Dobriyan wrote:
> It should be tiny little bit nicer to call them "ts[2]" because they're=

> timeSpecs.

I always use tv since the prefix of the element names hasn't been
changed.  ts.tv_sec vs tv.tv_sec.  The latter looks nicer.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig5B996CF09F0CC09F0F988B88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMjbq2ijCOnn/RHQRArJZAKC6v45uTrbJyXcCDsJcYdLx786flQCfaDK1
X5ObaIGhj7J3dAXXWZ50+w4=
=c86w
-----END PGP SIGNATURE-----

--------------enig5B996CF09F0CC09F0F988B88--
