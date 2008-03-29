Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYC2Mzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYC2Mzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYC2MzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:55:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36180 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYC2MzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:55:21 -0400
X-Sasl-enc: X6X8Hwop7RDD6KkGR6sOSRw8YxyT86IcGRvpUbA9jjLU 1206795319
Message-ID: <47EE3C29.2010908@imap.cc>
Date: Sat, 29 Mar 2008 13:55:05 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: Kconfig RTC selection
References: <20080327160700.GB828@suse.de> <200803280249.42193.david-b@pacbell.net> <47ECE9BB.3050006@imap.cc> <200803281222.33648.david-b@pacbell.net>
In-Reply-To: <200803281222.33648.david-b@pacbell.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig79772E66E538CF11D4966586"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79772E66E538CF11D4966586
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Mar 2008 12:22:32 -0700, David Brownell wrote:
> On Friday 28 March 2008, Tilman Schmidt wrote:
>> FWIW, it's still confusing to have an option "Enhanced Real Time
>> Clock Support" under "Character Devices", then later an option
>> "Real Time Clock" one level higher, none of the two in any way
>> acknowledging the existence of the other one, and only after
>> naively selecting both, you are told that there is some sort of
>> conflict.
>=20
> You mean "still, after applying that patch I sent"?

No, I was referring to the situation still existing in current mainline.
My comment was intended to be in support of your patches. Sorry for not
having made myself clear.

Regards,
Tilman


--------------enig79772E66E538CF11D4966586
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH7jw0Q3+did9BuFsRAgTgAKCU983VTGPndgbH7E0Xmrvn1sO9dgCfWKGe
x5m6KO2Mey+JgSuNCwxhi+o=
=E/FI
-----END PGP SIGNATURE-----

--------------enig79772E66E538CF11D4966586--
