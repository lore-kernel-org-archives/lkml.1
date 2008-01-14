Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYANUAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYANUAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYANT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:59:52 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:54263 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYANT7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:59:50 -0500
Message-ID: <478BBF31.9070105@web.de>
Date: Mon, 14 Jan 2008 20:59:45 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: State of kgdb on x86-64
References: <478BB35B.9060507@siemens.com> <478BB74E.6020506@windriver.com>
In-Reply-To: <478BB74E.6020506@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig971A9A3293A0D93F4E10ED1A"
X-Provags-ID: V01U2FsdGVkX1+SWlaqAPfd3TfSTIgWSNGOA+h/Sq1u4IjBphux
	pNUCC79sYHJuezFtpxU5q/yzkq+QdbI0ed3Q05hMS4MFv0G0t4
	p1sjcJKXE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig971A9A3293A0D93F4E10ED1A
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> It was working at the point that I tested it with the 2.6.24-rc5 on
> x86_64.  However I suspect my kernel config may differ drastically from=

> what you are using.

Yeah, that might be the case. The only thing I tried to vary so far was=20
applying maxcpus=3D1, but without success.

>=20
> Without any other context provided than the generic message, it is hard=

> to know what might have happened.=20

OK, will throw my .config over tomorrow or on Wednesday, it's out of=20
reach ATM. And if you have a reference .config, I would appreciate if=20
you could send it over.

Thanks,
Jan


--------------enig971A9A3293A0D93F4E10ED1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHi78zniDOoMHTA+kRAgSNAJ0bvV/Uj8pQ9yyqpVP7/HHLm+k0WQCeNg8c
CBZ3ghuFGnGgs7ZbAuvxafQ=
=VLZ5
-----END PGP SIGNATURE-----

--------------enig971A9A3293A0D93F4E10ED1A--
