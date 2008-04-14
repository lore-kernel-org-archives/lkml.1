Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYDNBIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYDNBIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYDNBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:08:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59319 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYDNBI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:08:27 -0400
X-Sasl-enc: 6+WgDC4supHFYQP4oOsNea9O0AnXmAWQhysb6xn4wJLh 1208135302
Message-ID: <4802AE84.4060400@imap.cc>
Date: Mon, 14 Apr 2008 03:08:20 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [Bug #10344] [2.6.25-rc6] possible regression: X server dying
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.Bu.C4lAIB@albercik>
In-Reply-To: <oq66hWjeF4N.A.Bu.C4lAIB@albercik>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig81832F432ABF16FFE9EE85FE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig81832F432ABF16FFE9EE85FE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 13.04.2008 20:56 schrieb Rafael J. Wysocki:
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D10344
> Subject		: [2.6.25-rc6] possible regression: X server dying
> Submitter	: Tilman Schmidt <tilman@imap.cc>
> Date		: 2008-03-24 23:38 (21 days old)
> References	: http://lkml.org/lkml/2008/3/24/260
> Handled-By	: Dave Airlie <airlied@gmail.com>

I have reproduced the issue on kernel 2.6.22.17, so it looks like it's
not a kernel regression, but an X server issue.

Thanks,
Tilman


--------------enig81832F432ABF16FFE9EE85FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIAq6EMdB4Whm86/kRAjawAJ9Z0cTMXQkKzABhYmaIzLU8e1fqTwCfe+rT
bLcc1Qx6x2N7N/XukQu6KYQ=
=HRzL
-----END PGP SIGNATURE-----

--------------enig81832F432ABF16FFE9EE85FE--
