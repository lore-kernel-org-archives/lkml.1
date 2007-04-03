Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXDCXzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXDCXzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXDCXzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:55:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbXDCXzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:55:10 -0400
Message-ID: <4612E93D.2030909@redhat.com>
Date: Tue, 03 Apr 2007 16:54:37 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com>	<20070403131623.c6831607.akpm@linux-foundation.org>	<4612BB89.8040102@redhat.com>	<20070403141348.9bcdb13e.akpm@linux-foundation.org>	<4612D175.30604@redhat.com>	<20070403154831.37bde672.akpm@linux-foundation.org>	<4612DCA2.2090400@redhat.com> <20070403162349.583adf84.akpm@linux-foundation.org>
In-Reply-To: <20070403162349.583adf84.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDAECC744AC5D5685A373721D"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDAECC744AC5D5685A373721D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Does anyone see a reason why we cannot do this?

Shouldn't sched_setaffinity get the same treatment for symmetry reasons?

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigDAECC744AC5D5685A373721D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEuk92ijCOnn/RHQRAhNqAKC48xjJbnOkCpILbzCKrCmHIwG/ZQCgyrBP
A9chdQmEjyIeqU3BY+99J48=
=bkkJ
-----END PGP SIGNATURE-----

--------------enigDAECC744AC5D5685A373721D--
