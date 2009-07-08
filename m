Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZGHPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZGHPym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZGHPyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:54:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60178 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZGHPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:54:35 -0400
Message-ID: <4A54C132.5040305@novell.com>
Date: Wed, 08 Jul 2009 11:54:26 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, zengzm.kernel@gmail.com
Subject: Re: [PATCH] sched_rt: fix overload bug on rt group scheduling -v2
References: <1238604015.8530.3666.camel@twins> <49D40DBF.8030507@novell.com>	 <1238654901.8530.5373.camel@twins>  <49D49FB6.3000101@novell.com> <1247067476.9777.57.camel@twins>
In-Reply-To: <1247067476.9777.57.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB0064E635EF1B3E8F9E8EFD8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0064E635EF1B3E8F9E8EFD8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> Greg, how's this?
>  =20

Quick glance looks reasonable.  I'll try to take a closer look this
afternoon.

-Greg



--------------enigB0064E635EF1B3E8F9E8EFD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpUwTYACgkQlOSOBdgZUxkg6wCdHumBP+1aalTGsRRFMK0FSoTc
35oAoIleB+HxsyE9Pnae9uVGJ1lJ4msE
=qL8E
-----END PGP SIGNATURE-----

--------------enigB0064E635EF1B3E8F9E8EFD8--
