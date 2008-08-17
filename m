Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYHQPRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYHQPRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYHQPQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:16:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42632 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbYHQPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:16:53 -0400
X-Sasl-enc: ZrHuYazo6M/w4BLVJqqyt5b7oVmHP0eU50GT1pST0tSm 1218986211
Message-ID: <48A840D6.8020906@imap.cc>
Date: Sun, 17 Aug 2008 17:16:38 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: PM_TRACE is no longer experimental
References: <20080814151833.GA23300@elf.ucw.cz> <48A5B8C8.6040504@imap.cc> <20080817093309.GA8368@atrey.karlin.mff.cuni.cz> <200808171223.41893.rjw@sisk.pl>
In-Reply-To: <200808171223.41893.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB149CC89A66CF3601CBFB50E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB149CC89A66CF3601CBFB50E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki schrieb:
> On Sunday, 17 of August 2008, Pavel Machek wrote:

>> Given that it is enabled in both 32-bit and 64-bit defconfig, I don't
>> think we can call it experimental.
>=20
> I agree.
>=20
>> Plus IIRC it needs command line option to thrash RTC.
>=20
> That's correct.

Alright, I withdraw my objection.

T.


--------------enigB149CC89A66CF3601CBFB50E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIqEDfQ3+did9BuFsRAlQgAJ0abngD6fBOBdGfLWmvecISpV0jxACffsrF
2Nvw5ew9JGpXOCxYqn1aC24=
=knkN
-----END PGP SIGNATURE-----

--------------enigB149CC89A66CF3601CBFB50E--
