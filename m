Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYHORMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYHORMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYHORLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:11:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58784 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYHORLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:11:52 -0400
X-Sasl-enc: tVe75RflzH2DG9Dl/mPKvU7fSRiORejkfGw43jo33YH3 1218820310
Message-ID: <48A5B8C8.6040504@imap.cc>
Date: Fri, 15 Aug 2008 19:11:36 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: PM_TRACE is no longer experimental
References: <20080814151833.GA23300@elf.ucw.cz>
In-Reply-To: <20080814151833.GA23300@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig26449AB899140A6BAEA33BFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig26449AB899140A6BAEA33BFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14.08.2008 17:18 Pavel Machek wrote:
> PM_TRACE is stable for quite long. I don't think it needs to depend on
> experimental.

It might be stable, but its effect of trashing the RTC makes it unsuitabl=
e
for non-experimental use. Therefore I'd prefer the dependency be kept.

Thanks,
Tilman


--------------enig26449AB899140A6BAEA33BFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIpbjTQ3+did9BuFsRAqW9AJ0W2OXIimnD3w8KOXOLOyaysTLenACfbH7L
AD+7eWYVx03+vzCnJQmLw8E=
=bYEC
-----END PGP SIGNATURE-----

--------------enig26449AB899140A6BAEA33BFF--
